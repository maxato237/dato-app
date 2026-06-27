import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import 'package:dato/core/network/api_client.dart';
import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_button.dart';
import 'package:dato/core/widgets/dato_toast.dart';
import 'package:dato/features/pdf/template_pdf.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quote_editor_controller.dart';
import 'package:dato/features/quotes/widgets/quote_document.dart';
import 'package:dato/features/quotes/widgets/share_sheet.dart';
import 'package:dato/features/settings/domain/company.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class QuotePreviewScreen extends ConsumerWidget {
  const QuotePreviewScreen({super.key, required this.quoteId});

  final String quoteId;

  static const _pageBg = Color(0xFFECEFF3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote =
        ref.watch(quoteEditorControllerProvider(quoteId)).quote;
    final company = ref.watch(currentCompanyProvider);

    void share() =>
        showShareSheet(context, quote: quote, company: company);

    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context, share),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                child: Column(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        border: Border.all(color: const Color(0xFFD7DDE4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      // Avec un modèle Word : on affiche le vrai rendu du PDF
                      // généré par le backend (en-tête / pied de page du Word).
                      // Sinon : rendu Flutter du format par défaut.
                      child: company.hasTemplate
                          ? _TemplatePreview(
                              api: ref.read(apiClientProvider),
                              quote: quote,
                              company: company,
                            )
                          : QuoteDocument(
                              company: company, quote: quote, compact: true),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('Page 1 / 1 · Format A4',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textLight)),
                    ),
                  ],
                ),
              ),
            ),
            _actionBar(context, ref, quote, company, share),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, VoidCallback onShare) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(6, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 26),
            color: AppColors.textMuted,
            onPressed: () =>
                context.canPop() ? context.pop() : context.go(Routes.home),
            tooltip: 'Retour',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Aperçu du devis',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
                const Text('Rendu final avant envoi',
                    style:
                        TextStyle(fontSize: 11.5, color: AppColors.textLight)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: IconButton(
              key: const Key('preview-share'),
              icon: const Icon(Icons.ios_share, size: 20),
              color: AppColors.textMuted,
              onPressed: onShare,
              tooltip: 'Partager',
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBar(BuildContext context, WidgetRef ref, Quote quote,
      Company company, VoidCallback onShare) {
    // Réserve l'inset de la barre système Android (même logique que la
    // bottom-nav et la barre de l'éditeur) pour que « PDF » / « Partager »
    // soient au-dessus du menu de navigation Android.
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F101828),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(14, 10, 14, 14 + bottomInset),
      child: Row(
        children: [
          Expanded(
            child: DatoButton.secondary(
              key: const Key('preview-pdf'),
              label: 'PDF',
              icon: const Icon(Icons.download_outlined, size: 19),
              onPressed: () => _exportPdf(context, ref, quote, company),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DatoButton.whatsapp(
              key: const Key('preview-partager'),
              label: 'Partager',
              icon: const Icon(Icons.chat_outlined, size: 19),
              onPressed: onShare,
            ),
          ),
        ],
      ),
    );
  }

  /// Génère puis partage le PDF (modèle Word backend ou rendu local), avec
  /// un indicateur de chargement pendant la génération.
  Future<void> _exportPdf(BuildContext context, WidgetRef ref, Quote quote,
      Company company) async {
    final api = ref.read(apiClientProvider);
    final rootNav = Navigator.of(context, rootNavigator: true);
    final ctx = rootNav.context;
    showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final bytes =
          await resolveQuotePdf(apiClient: api, quote: quote, company: company);
      rootNav.pop();
      await Printing.sharePdf(
          bytes: bytes, filename: 'Devis-${quote.number}.pdf');
    } catch (_) {
      rootNav.pop();
      if (!ctx.mounted) return;
      DatoToast.show(ctx,
          message: 'Échec de la génération du PDF',
          variant: DatoToastVariant.error);
    }
  }
}

/// Aperçu rasterisé du PDF généré par le backend (modèle Word).
///
/// Récupère le PDF puis le convertit en images page par page via
/// `Printing.raster`. En cas d'échec, retombe sur le rendu Flutter par défaut.
class _TemplatePreview extends StatefulWidget {
  const _TemplatePreview({
    required this.api,
    required this.quote,
    required this.company,
  });

  final ApiClient api;
  final Quote quote;
  final Company company;

  @override
  State<_TemplatePreview> createState() => _TemplatePreviewState();
}

class _TemplatePreviewState extends State<_TemplatePreview> {
  late final Future<List<Uint8List>> _pages = _load();

  Future<List<Uint8List>> _load() async {
    final bytes = await resolveQuotePdf(
      apiClient: widget.api,
      quote: widget.quote,
      company: widget.company,
    );
    final pages = <Uint8List>[];
    await for (final page in Printing.raster(bytes, dpi: 144)) {
      pages.add(await page.toPng());
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Uint8List>>(
      future: _pages,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const ColoredBox(
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1 / 1.414, // A4
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final pages = snap.data ?? const <Uint8List>[];
        if (snap.hasError || pages.isEmpty) {
          // Repli : rendu Flutter du format par défaut.
          return QuoteDocument(
              company: widget.company, quote: widget.quote, compact: true);
        }
        // Fond blanc derrière les pages : le PNG rasterisé est transparent là
        // où le PDF ne peint rien — sans ça, le gris de la page transparaît.
        return ColoredBox(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final png in pages)
                Image.memory(png, fit: BoxFit.fitWidth),
            ],
          ),
        );
      },
    );
  }
}
