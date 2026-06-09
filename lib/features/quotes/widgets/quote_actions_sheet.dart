import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/id.dart';
import 'package:dato/core/widgets/dato_bottom_sheet.dart';
import 'package:dato/core/widgets/dato_toast.dart';
import 'package:dato/core/widgets/status_badge.dart';
import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/pdf/quote_pdf.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/widgets/share_sheet.dart';
import 'package:dato/features/settings/domain/company.dart';

enum _QuoteAction { edit, duplicate, share, pdf, status, delete }

/// Ouvre le menu d'actions d'un devis (Voir / Dupliquer / Partager / PDF /
/// Statut / Supprimer) puis exécute le choix.
Future<void> showQuoteActions(
  BuildContext context,
  WidgetRef ref, {
  required Quote quote,
  required Company company,
}) async {
  final action = await DatoBottomSheet.show<_QuoteAction>(
    context: context,
    showDragHandle: true,
    child: const _ActionsMenu(),
  );
  if (action == null || !context.mounted) return;

  switch (action) {
    case _QuoteAction.edit:
      context.push(Routes.quoteEditorPath(quote.id));
    case _QuoteAction.duplicate:
      await _duplicate(context, ref, quote);
    case _QuoteAction.share:
      await showShareSheet(context, quote: quote, company: company);
    case _QuoteAction.pdf:
      final bytes = await buildQuotePdf(quote: quote, company: company);
      await Printing.sharePdf(
          bytes: bytes, filename: 'Devis-${quote.number}.pdf');
    case _QuoteAction.status:
      await _changeStatus(context, ref, quote);
    case _QuoteAction.delete:
      await _confirmDelete(context, ref, quote);
  }
}

class _ActionsMenu extends StatelessWidget {
  const _ActionsMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(context, Icons.visibility_outlined, 'Voir / Éditer',
            _QuoteAction.edit),
        _row(context, Icons.copy_outlined, 'Dupliquer',
            _QuoteAction.duplicate),
        _row(context, Icons.ios_share, 'Partager', _QuoteAction.share),
        _row(context, Icons.download_outlined, 'Télécharger le PDF',
            _QuoteAction.pdf),
        const Divider(height: 9),
        _row(context, Icons.check_circle_outline, 'Changer le statut',
            _QuoteAction.status),
        _row(context, Icons.delete_outline, 'Supprimer', _QuoteAction.delete,
            danger: true),
      ],
    );
  }

  Widget _row(BuildContext context, IconData icon, String label,
      _QuoteAction action,
      {bool danger = false}) {
    final color = danger ? AppColors.danger : AppColors.text;
    return InkWell(
      key: Key('action-${action.name}'),
      onTap: () => Navigator.of(context).pop(action),
      borderRadius: BorderRadius.circular(AppRadii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }
}

Future<void> _duplicate(BuildContext context, WidgetRef ref, Quote quote) async {
  final repo = ref.read(quoteRepositoryProvider);
  final copy = Quote(
    id: newId(),
    number: _nextNumber(repo),
    date: _todayIso(),
    object: quote.object,
    client: quote.client,
    status: QuoteStatus.draft,
    sections: quote.sections,
    rubriques: quote.rubriques,
    signatures: quote.signatures,
    companyId: quote.companyId,
    note: quote.note,
  );
  await repo.save(copy);
  if (!context.mounted) return;
  DatoToast.show(context,
      message: 'Devis dupliqué', variant: DatoToastVariant.success);
}

Future<void> _changeStatus(
    BuildContext context, WidgetRef ref, Quote quote) async {
  final status = await DatoBottomSheet.show<QuoteStatus>(
    context: context,
    title: 'Changer le statut',
    child: _StatusChooser(current: quote.status),
  );
  if (status == null || status == quote.status || !context.mounted) return;
  await ref.read(quoteRepositoryProvider).save(quote.copyWith(status: status));
  if (!context.mounted) return;
  DatoToast.show(context,
      message: 'Statut mis à jour', variant: DatoToastVariant.success);
}

Future<void> _confirmDelete(
    BuildContext context, WidgetRef ref, Quote quote) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Supprimer ce devis ?'),
      content: Text(
          '« ${quote.object.isEmpty ? quote.number : quote.object} » sera définitivement supprimé.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.danger),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  await ref.read(quoteRepositoryProvider).delete(quote.id);
  if (!context.mounted) return;
  DatoToast.show(context,
      message: 'Devis supprimé', variant: DatoToastVariant.success);
}

class _StatusChooser extends StatelessWidget {
  const _StatusChooser({required this.current});

  final QuoteStatus current;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final s in QuoteStatus.values)
          InkWell(
            key: Key('status-${s.name}'),
            onTap: () => Navigator.of(context).pop(s),
            borderRadius: BorderRadius.circular(AppRadii.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  StatusBadge(status: s),
                  const Spacer(),
                  if (s == current)
                    const Icon(Icons.check, size: 20, color: AppColors.ink),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

String _todayIso() {
  final now = DateTime.now();
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '${now.year}-$m-$d';
}

String _nextNumber(QuoteRepository repo) {
  final year = DateTime.now().year;
  final seq = (repo.getAll().length + 1).toString().padLeft(3, '0');
  return 'DV-$year-$seq';
}
