import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/widgets/dato_bottom_sheet.dart';
import 'package:dato/core/widgets/dato_button.dart';
import 'package:dato/core/widgets/dato_toast.dart';
import 'package:dato/features/pdf/quote_pdf.dart';
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

/// Lien public provisoire — remplacé par un vrai token révocable en Phase 6.
String _publicLink(Quote quote) => 'https://dato.app/p/${quote.id}';

String _shareText(Quote quote) =>
    'Devis ${quote.number} — ${quote.object}\n'
    'Montant : ${formatFcfa(quote.grandTotal)}\n${_publicLink(quote)}';

class ShareSheetContent extends StatelessWidget {
  const ShareSheetContent({
    super.key,
    required this.quote,
    required this.company,
  });

  final Quote quote;
  final Company company;

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => _whatsapp(context),
        ),
        const SizedBox(height: 10),
        DatoButton.secondary(
          key: const Key('share-copy'),
          label: 'Copier le lien',
          icon: const Icon(Icons.copy_outlined, size: 19),
          onPressed: () => _copyLink(context),
        ),
        const SizedBox(height: 10),
        DatoButton.secondary(
          key: const Key('share-pdf'),
          label: 'Télécharger le PDF',
          icon: const Icon(Icons.download_outlined, size: 19),
          onPressed: () => _downloadPdf(context),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          key: const Key('share-email'),
          onPressed: () => _email(context),
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

  Future<void> _whatsapp(BuildContext context) async {
    Navigator.of(context).pop();
    final text = _shareText(quote);
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

  Future<void> _copyLink(BuildContext context) async {
    Navigator.of(context).pop();
    await Clipboard.setData(ClipboardData(text: _publicLink(quote)));
    if (!context.mounted) return;
    DatoToast.show(context,
        message: 'Lien copié dans le presse-papier',
        variant: DatoToastVariant.success);
  }

  Future<void> _downloadPdf(BuildContext context) async {
    Navigator.of(context).pop();
    final bytes = await buildQuotePdf(quote: quote, company: company);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'Devis-${quote.number}.pdf',
    );
  }

  Future<void> _email(BuildContext context) async {
    Navigator.of(context).pop();
    final subject = 'Devis ${quote.number} — ${company.name}';
    final body = _shareText(quote);
    final uri = Uri.parse(
        'mailto:?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}');
    try {
      await launchUrl(uri);
    } catch (_) {
      if (!context.mounted) return;
      DatoToast.show(context,
          message: "Aucune application e-mail trouvée",
          variant: DatoToastVariant.error);
    }
  }
}
