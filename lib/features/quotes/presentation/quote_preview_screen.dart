import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_button.dart';
import 'package:dato/features/pdf/quote_pdf.dart';
import 'package:dato/features/quotes/providers/quote_editor_controller.dart';
import 'package:dato/features/quotes/widgets/quote_document.dart';
import 'package:dato/features/quotes/widgets/share_sheet.dart';
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
                      child: QuoteDocument(
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

  Widget _actionBar(BuildContext context, WidgetRef ref, quote, company,
      VoidCallback onShare) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: DatoButton.secondary(
              key: const Key('preview-pdf'),
              label: 'PDF',
              icon: const Icon(Icons.download_outlined, size: 19),
              onPressed: () async {
                final bytes =
                    await buildQuotePdf(quote: quote, company: company);
                await Printing.sharePdf(
                    bytes: bytes, filename: 'Devis-${quote.number}.pdf');
              },
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
}
