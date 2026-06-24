import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dato/core/network/network_providers.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/widgets/dato_bottom_sheet.dart';
import 'package:dato/core/widgets/dato_button.dart';
import 'package:dato/core/widgets/dato_toast.dart';
import 'package:dato/features/pdf/template_pdf.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

/// Ouvre le bottom sheet « Partager le devis ».
Future<void> showShareSheet(
  BuildContext context, {
  required Quote quote,
  required Company company,
}) {
  return DatoBottomSheet.show(
    context: context,
    showDragHandle: true,
    child: ShareSheetContent(quote: quote, company: company),
  );
}

class ShareSheetContent extends ConsumerWidget {
  const ShareSheetContent({
    super.key,
    required this.quote,
    required this.company,
  });

  final Quote quote;
  final Company company;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Partager le devis',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.textMuted,
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Fermer',
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s4),
          child: Text(
            quote.object.isEmpty ? quote.number : quote.object,
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
        ),
        DatoButton.whatsapp(
          key: const Key('share-whatsapp'),
          label: 'Partager sur WhatsApp',
          icon: const Icon(Icons.chat_outlined, size: 20),
          onPressed: () => _whatsapp(context, ref),
        ),
        const SizedBox(height: 10),
        DatoButton.secondary(
          key: const Key('share-copy'),
          label: 'Copier le lien',
          icon: const Icon(Icons.copy_outlined, size: 19),
          onPressed: () => _copyLink(context, ref),
        ),
        const SizedBox(height: 10),
        DatoButton.secondary(
          key: const Key('share-pdf'),
          label: 'Télécharger le PDF',
          icon: const Icon(Icons.download_outlined, size: 19),
          onPressed: () => _downloadPdf(context, ref),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          key: const Key('share-email'),
          onPressed: () => _email(context, ref),
          icon: const Icon(Icons.send_outlined, size: 18),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textMuted,
            minimumSize: const Size.fromHeight(kMinTapTarget),
          ),
          label: const Text('Envoyer par e-mail'),
        ),
      ],
    );
  }

  /// Lien public partageable. Active le lien côté backend et renvoie son URL ;
  /// repli local si le devis n'est pas encore synchronisé (hors-ligne).
  Future<String> _resolvePublicUrl(WidgetRef ref) async {
    try {
      return await ref.read(quoteRemoteDataSourceProvider).enableShare(quote.id);
    } catch (_) {
      return 'https://dato.app/p/${quote.id}';
    }
  }

  String _shareText(String link) =>
      'Devis ${quote.number} — ${quote.object}\n'
      'Montant : ${formatFcfa(quote.grandTotal)}\n$link';

  Future<void> _whatsapp(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    final text = _shareText(await _resolvePublicUrl(ref));
    final uri = Uri.parse('whatsapp://send?text=${Uri.encodeComponent(text)}');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await Share.share(text);
      }
    } catch (_) {
      await Share.share(text);
    }
  }

  Future<void> _copyLink(BuildContext context, WidgetRef ref) async {
    final ctx = Navigator.of(context, rootNavigator: true).context;
    Navigator.of(context).pop();
    final link = await _resolvePublicUrl(ref);
    await Clipboard.setData(ClipboardData(text: link));
    if (!ctx.mounted) return;
    DatoToast.show(ctx,
        message: 'Lien copié dans le presse-papier',
        variant: DatoToastVariant.success);
  }

  Future<void> _downloadPdf(BuildContext context, WidgetRef ref) async {
    final api = ref.read(apiClientProvider);
    final rootNav = Navigator.of(context, rootNavigator: true);
    final ctx = rootNav.context;
    Navigator.of(context).pop(); // ferme le bottom sheet

    // Indicateur de chargement (la génération via modèle Word peut prendre
    // quelques secondes côté backend).
    showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final bytes =
          await resolveQuotePdf(apiClient: api, quote: quote, company: company);
      rootNav.pop(); // ferme le loader
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'Devis-${quote.number}.pdf',
      );
    } catch (_) {
      rootNav.pop();
      if (!ctx.mounted) return;
      DatoToast.show(ctx,
          message: 'Échec de la génération du PDF',
          variant: DatoToastVariant.error);
    }
  }

  Future<void> _email(BuildContext context, WidgetRef ref) async {
    final ctx = Navigator.of(context, rootNavigator: true).context;
    Navigator.of(context).pop();
    final subject = 'Devis ${quote.number} — ${company.name}';
    final body = _shareText(await _resolvePublicUrl(ref));
    final uri = Uri.parse(
        'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');
    try {
      await launchUrl(uri);
    } catch (_) {
      if (!ctx.mounted) return;
      DatoToast.show(ctx,
          message: "Aucune application e-mail trouvée",
          variant: DatoToastVariant.error);
    }
  }
}
