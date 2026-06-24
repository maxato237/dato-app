import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_button.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quote_editor_controller.dart';
import 'package:dato/features/quotes/widgets/inline_text_field.dart';
import 'package:dato/features/quotes/widgets/rubrique_card.dart';
import 'package:dato/features/quotes/widgets/section_card.dart';
import 'package:dato/features/quotes/widgets/share_sheet.dart';
import 'package:dato/features/quotes/widgets/total_card.dart';
import 'package:dato/features/library/providers/articles_provider.dart';
import 'package:dato/features/settings/domain/company.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class QuoteEditorScreen extends ConsumerStatefulWidget {
  const QuoteEditorScreen({super.key, required this.quoteId});

  final String quoteId;

  @override
  ConsumerState<QuoteEditorScreen> createState() => _QuoteEditorScreenState();
}

class _QuoteEditorScreenState extends ConsumerState<QuoteEditorScreen> {
  late final TextEditingController _objectCtrl;
  late final TextEditingController _clientCtrl;
  late final TextEditingController _dateCtrl;

  QuoteEditorController get _controller =>
      ref.read(quoteEditorControllerProvider(widget.quoteId).notifier);

  @override
  void initState() {
    super.initState();
    final q = ref.read(quoteEditorControllerProvider(widget.quoteId)).quote;
    _objectCtrl = TextEditingController(text: q.object);
    _clientCtrl = TextEditingController(text: q.client);
    _dateCtrl = TextEditingController(text: _displayDate(q.date));
  }

  @override
  void dispose() {
    _objectCtrl.dispose();
    _clientCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quoteEditorControllerProvider(widget.quoteId));
    final quote = state.quote;
    final company = ref.watch(currentCompanyProvider);
    final articles = ref.watch(articlesProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context, quote.object, state.saveStatus),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _companyCard(context, company),
                    const SizedBox(height: 14),
                    _infosCard(context),
                    const SizedBox(height: 14),
                    _kicker('Sections & lignes'),
                    const SizedBox(height: 8),
                    ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quote.sections.length,
                      onReorder: _controller.reorderSections,
                      itemBuilder: (context, i) {
                        final s = quote.sections[i];
                        return Padding(
                          key: ValueKey(s.id),
                          padding: const EdgeInsets.only(bottom: 14),
                          child: SectionCard(
                            section: s,
                            sectionIndex: i,
                            articles: articles,
                            controller: _controller,
                          ),
                        );
                      },
                    ),
                    _addButton(
                      key: const Key('add-section'),
                      icon: Icons.layers_outlined,
                      label: 'Ajouter une section',
                      color: AppColors.ink,
                      onTap: _controller.addSection,
                    ),
                    const SizedBox(height: 14),
                    _kicker("Rubriques (transport, usinage, main d'œuvre…)"),
                    const SizedBox(height: 8),
                    ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quote.rubriques.length,
                      onReorder: _controller.reorderRubriques,
                      itemBuilder: (context, i) {
                        final r = quote.rubriques[i];
                        return Padding(
                          key: ValueKey(r.id),
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RubriqueCard(
                            rubrique: r,
                            rubriqueIndex: i,
                            controller: _controller,
                          ),
                        );
                      },
                    ),
                    _addButton(
                      key: const Key('add-rubrique'),
                      icon: Icons.add,
                      label: 'Ajouter une rubrique',
                      color: AppColors.amber700,
                      onTap: _controller.addRubrique,
                    ),
                    const SizedBox(height: 14),
                    TotalCard(total: quote.grandTotal),
                    const SizedBox(height: 14),
                    _kicker('Blocs de signature'),
                    const SizedBox(height: 8),
                    _signaturesCard(context, quote),
                    if (company.hasLocation) ...[
                      const SizedBox(height: 14),
                      _kicker('Pied de page'),
                      const SizedBox(height: 8),
                      _footerPreview(company),
                    ],
                  ],
                ),
              ),
            ),
            _actionBar(context),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // En-tête
  // ---------------------------------------------------------------------------
  Widget _header(BuildContext context, String object, SaveStatus status) {
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
                Text(
                  object.isEmpty ? 'Nouveau devis' : object,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 1),
                _saveIndicator(status),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: IconButton(
              icon: const Icon(Icons.visibility_outlined, size: 20),
              color: AppColors.textMuted,
              onPressed: _openPreview,
              tooltip: 'Aperçu',
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveIndicator(SaveStatus status) {
    if (status == SaveStatus.saving) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 11,
            height: 11,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.amber),
          ),
          SizedBox(width: 5),
          Text('Enregistrement…',
              style: TextStyle(fontSize: 11.5, color: AppColors.amber700)),
        ],
      );
    }
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_done_outlined, size: 13, color: AppColors.green700),
        SizedBox(width: 5),
        Text('Enregistré',
            style: TextStyle(fontSize: 11.5, color: AppColors.green700)),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // En-tête entreprise (lecture seule)
  // ---------------------------------------------------------------------------
  Widget _companyCard(BuildContext context, Company company) {
    final head = Theme.of(context).textTheme.titleLarge!;

    final Widget logoWidget = company.hasLogo
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              company.logoUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _initialBox(context, head, company.initial),
            ),
          )
        : _initialBox(context, head, company.initial);

    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      child: Row(
        children: [
          logoWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(company.name,
                    style: head.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink)),
                Text(company.activity,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 12, color: AppColors.textLight),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text('En-tête modifiable dans Réglages',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textLight)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: content,
    );
  }

  Widget _initialBox(BuildContext context, TextStyle head, String initial) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: head.copyWith(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _footerPreview(Company company) {
    // Bandeau coloré avec le texte de localisation (plus d'image de fond).
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      alignment: Alignment.center,
      child: Text(
        company.location,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Infos devis (objet, client, date)
  // ---------------------------------------------------------------------------
  Widget _infosCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Objet du devis'),
          const SizedBox(height: 6),
          TextField(
            key: const Key('field-objet'),
            controller: _objectCtrl,
            onChanged: _controller.setObject,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                hintText: 'Ex. Fabrication de 40 chaises…'),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Client'),
          const SizedBox(height: 6),
          TextField(
            key: const Key('field-client'),
            controller: _clientCtrl,
            onChanged: _controller.setClient,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Nom du client'),
          ),
          const SizedBox(height: 12),
          _fieldLabel('Date'),
          const SizedBox(height: 6),
          TextField(
            key: const Key('field-date'),
            controller: _dateCtrl,
            readOnly: true,
            onTap: _pickDate,
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.text)),
        if (trailing != null) trailing,
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Signatures
  // ---------------------------------------------------------------------------
  Widget _signaturesCard(BuildContext context, Quote quote) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final s in quote.signatures)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderStrong, width: 1.5),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit_outlined,
                      size: 15, color: AppColors.textLight),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 110,
                    child: InlineTextField(
                      value: s.label,
                      style: const TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.w500),
                      onChanged: (v) =>
                          _controller.setSignatureLabel(s.id, v),
                    ),
                  ),
                  InkWell(
                    onTap: () => _controller.deleteSignature(s.id),
                    child: const Icon(Icons.close,
                        size: 15, color: AppColors.textLight),
                  ),
                ],
              ),
            ),
          InkWell(
            key: const Key('add-signature'),
            onTap: _controller.addSignature,
            borderRadius: BorderRadius.circular(AppRadii.md),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderStrong, width: 1.5),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 15, color: AppColors.ink),
                  SizedBox(width: 6),
                  Text('Ajouter',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Barre d'action
  // ---------------------------------------------------------------------------
  Widget _actionBar(BuildContext context) {
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
              label: 'Aperçu',
              icon: const Icon(Icons.visibility_outlined, size: 19),
              onPressed: _openPreview,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DatoButton.whatsapp(
              key: const Key('btn-partager'),
              label: 'Partager',
              icon: const Icon(Icons.chat_outlined, size: 19),
              onPressed: _onShare,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers UI
  // ---------------------------------------------------------------------------
  Widget _kicker(String text) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
            color: AppColors.textLight,
          ),
    );
  }

  Widget _addButton({
    required Key key,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderStrong, width: 1.5),
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Flexible(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600, color: color)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------
  void _onShare() {
    final quote = ref.read(quoteEditorControllerProvider(widget.quoteId)).quote;
    final company = ref.read(currentCompanyProvider);
    showShareSheet(context, quote: quote, company: company);
  }

  void _openPreview() =>
      context.push(Routes.quotePreviewPath(widget.quoteId));

  Future<void> _pickDate() async {
    final current = DateTime.tryParse(
            ref.read(quoteEditorControllerProvider(widget.quoteId)).quote.date) ??
        DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    final iso = _isoDate(picked);
    _controller.setDate(iso);
    _dateCtrl.text = _displayDate(iso);
  }

  static String _isoDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  static String _displayDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$day/$m/${d.year}';
  }
}
