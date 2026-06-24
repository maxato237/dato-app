import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/utils/id.dart';
import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/library/providers/articles_provider.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

/// État de l'auto-enregistrement, reflété par l'indicateur d'en-tête.
enum SaveStatus { saving, saved }

/// État de l'écran éditeur : le devis travaillé + le statut de sauvegarde.
class QuoteEditorState {
  final Quote quote;
  final SaveStatus saveStatus;

  const QuoteEditorState({required this.quote, required this.saveStatus});

  QuoteEditorState copyWith({Quote? quote, SaveStatus? saveStatus}) =>
      QuoteEditorState(
        quote: quote ?? this.quote,
        saveStatus: saveStatus ?? this.saveStatus,
      );
}

/// Délai d'inactivité avant écriture locale (cf. ARCHITECTURE.md).
const Duration kAutosaveDebounce = Duration(milliseconds: 800);

/// Contrôleur de l'éditeur de devis (un par `quoteId`).
///
/// Chaque édition produit une **nouvelle instance immuable** de [Quote]
/// (recalcul des totaux instantané), passe l'indicateur en
/// [SaveStatus.saving], puis écrit dans [QuoteRepository] après un debounce.
class QuoteEditorController
    extends AutoDisposeFamilyNotifier<QuoteEditorState, String> {
  late final QuoteRepository _repo;
  Timer? _debounce;
  bool _disposed = false;

  @override
  QuoteEditorState build(String arg) {
    _repo = ref.watch(quoteRepositoryProvider);
    ref.onDispose(() {
      _debounce?.cancel();
      _disposed = true;
    });

    final existing = arg == 'new' ? null : _repo.getById(arg);
    if (existing != null) {
      return QuoteEditorState(quote: existing, saveStatus: SaveStatus.saved);
    }
    // Nouveau devis : on le crée et on le persiste immédiatement.
    final fresh = _newQuote();
    _repo.save(fresh);
    return QuoteEditorState(quote: fresh, saveStatus: SaveStatus.saved);
  }

  // ---------------------------------------------------------------------------
  // Mutation centrale : remplace le devis, passe en « Enregistrement… »,
  // programme l'écriture locale.
  // ---------------------------------------------------------------------------
  void _apply(Quote quote) {
    state = QuoteEditorState(quote: quote, saveStatus: SaveStatus.saving);
    _debounce?.cancel();
    _debounce = Timer(kAutosaveDebounce, () async {
      await _repo.save(state.quote);
      _autoSaveArticles(state.quote);
      if (_disposed) return;
      state = state.copyWith(saveStatus: SaveStatus.saved);
    });
  }

  /// Mémorise dans la bibliothèque les désignations saisies dans le devis qui
  /// n'y figurent pas encore (auto-enregistrement des articles).
  void _autoSaveArticles(Quote quote) {
    final notifier = ref.read(articlesNotifierProvider.notifier);
    for (final section in quote.sections) {
      for (final line in section.lines) {
        if (line.designation.trim().isNotEmpty) {
          notifier.ensure(line.designation, line.pu.round());
        }
      }
    }
  }

  Quote _withSections(List<Section> sections) =>
      state.quote.copyWith(sections: sections);
  Quote _withRubriques(List<Rubrique> rubriques) =>
      state.quote.copyWith(rubriques: rubriques);

  // ---- En-tête ----
  void setObject(String v) {
    var quote = state.quote.copyWith(object: v);
    // Numérotation « par objet » : le numéro suit l'objet en temps réel.
    if (ref.read(currentCompanyProvider).quoteNumberByObject) {
      quote = quote.copyWith(number: _composeNumber(v));
    }
    _apply(quote);
  }

  void setClient(String v) => _apply(state.quote.copyWith(client: v));
  void setDate(String v) => _apply(state.quote.copyWith(date: v));

  // ---- Sections ----
  void addSection() {
    final section = Section(
      id: newId(),
      title: 'Nouvelle section',
      lines: [SectionLine(id: newId(), designation: '', qty: 1, pu: 0)],
    );
    _apply(_withSections([...state.quote.sections, section]));
  }

  void deleteSection(String sectionId) => _apply(_withSections(
      state.quote.sections.where((s) => s.id != sectionId).toList()));

  void setSectionTitle(String sectionId, String title) =>
      _apply(_withSections(state.quote.sections
          .map((s) => s.id == sectionId ? s.copyWith(title: title) : s)
          .toList()));

  void setSectionShowTitle(String sectionId, bool showTitle) =>
      _apply(_withSections(state.quote.sections
          .map((s) =>
              s.id == sectionId ? s.copyWith(showTitle: showTitle) : s)
          .toList()));

  void reorderSections(int oldIndex, int newIndex) =>
      _apply(_withSections(_reorder(state.quote.sections, oldIndex, newIndex)));

  // ---- Lignes de section ----
  void addLine(String sectionId) => _apply(_mapSection(sectionId, (s) =>
      s.copyWith(lines: [
        ...s.lines,
        SectionLine(id: newId(), designation: '', qty: 1, pu: 0),
      ])));

  void deleteLine(String sectionId, String lineId) => _apply(_mapSection(
      sectionId,
      (s) => s.copyWith(lines: s.lines.where((l) => l.id != lineId).toList())));

  void setLine(String sectionId, String lineId,
          {String? designation, double? qty, double? pu}) =>
      _apply(_mapSection(
          sectionId,
          (s) => s.copyWith(
              lines: s.lines
                  .map((l) => l.id == lineId
                      ? l.copyWith(designation: designation, qty: qty, pu: pu)
                      : l)
                  .toList())));

  void pickArticle(String sectionId, String lineId, Article article) =>
      _apply(_mapSection(
          sectionId,
          (s) => s.copyWith(
              lines: s.lines
                  .map((l) => l.id == lineId
                      ? l.copyWith(
                          designation: article.name, pu: article.pu.toDouble())
                      : l)
                  .toList())));

  void reorderLines(String sectionId, int oldIndex, int newIndex) =>
      _apply(_mapSection(sectionId,
          (s) => s.copyWith(lines: _reorder(s.lines, oldIndex, newIndex))));

  // ---- Rubriques ----
  void addRubrique() {
    final rubrique = Rubrique(
      id: newId(),
      label: 'Nouvelle rubrique',
      lines: [RubriqueLine(id: newId(), mode: RubriqueMode.forfait, amount: 0)],
    );
    _apply(_withRubriques([...state.quote.rubriques, rubrique]));
  }

  void deleteRubrique(String rubId) => _apply(_withRubriques(
      state.quote.rubriques.where((r) => r.id != rubId).toList()));

  void setRubriqueLabel(String rubId, String label) =>
      _apply(_withRubriques(state.quote.rubriques
          .map((r) => r.id == rubId ? r.copyWith(label: label) : r)
          .toList()));

  void reorderRubriques(int oldIndex, int newIndex) => _apply(
      _withRubriques(_reorder(state.quote.rubriques, oldIndex, newIndex)));

  // ---- Lignes de rubrique (forfait / formule) ----
  void setRubriqueLineMode(String rubId, String lineId, RubriqueMode mode) =>
      _apply(_mapRubriqueLine(rubId, lineId, (l) => l.copyWith(mode: mode)));

  void setRubriqueLineAmount(String rubId, String lineId, double amount) =>
      _apply(
          _mapRubriqueLine(rubId, lineId, (l) => l.copyWith(amount: amount)));

  void setRubriqueLineA(String rubId, String lineId, double a) =>
      _apply(_mapRubriqueLine(rubId, lineId, (l) => l.copyWith(a: a)));

  void setRubriqueLineB(String rubId, String lineId, double b) =>
      _apply(_mapRubriqueLine(rubId, lineId, (l) => l.copyWith(b: b)));

  void addSubLine(String rubId) => _apply(_mapRubrique(
      rubId,
      (r) => r.copyWith(lines: [
            ...r.lines,
            RubriqueLine(
                id: newId(),
                mode: RubriqueMode.formula,
                sublabel: '',
                a: 0,
                b: 0),
          ])));

  void deleteSubLine(String rubId, String lineId) => _apply(_mapRubrique(rubId,
      (r) => r.copyWith(lines: r.lines.where((l) => l.id != lineId).toList())));

  // ---- Signatures ----
  void addSignature() => _apply(state.quote.copyWith(signatures: [
        ...state.quote.signatures,
        Signature(id: newId(), label: 'Signature'),
      ]));

  void setSignatureLabel(String sigId, String label) =>
      _apply(state.quote.copyWith(
          signatures: state.quote.signatures
              .map((s) => s.id == sigId ? Signature(id: s.id, label: label) : s)
              .toList()));

  void deleteSignature(String sigId) => _apply(state.quote.copyWith(
      signatures:
          state.quote.signatures.where((s) => s.id != sigId).toList()));

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  Quote _mapSection(String sectionId, Section Function(Section) f) =>
      _withSections(state.quote.sections
          .map((s) => s.id == sectionId ? f(s) : s)
          .toList());

  Quote _mapRubrique(String rubId, Rubrique Function(Rubrique) f) =>
      _withRubriques(state.quote.rubriques
          .map((r) => r.id == rubId ? f(r) : r)
          .toList());

  Quote _mapRubriqueLine(
          String rubId, String lineId, RubriqueLine Function(RubriqueLine) f) =>
      _mapRubrique(
          rubId,
          (r) => r.copyWith(
              lines:
                  r.lines.map((l) => l.id == lineId ? f(l) : l).toList()));

  static List<T> _reorder<T>(List<T> source, int oldIndex, int newIndex) {
    final list = [...source];
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    return list;
  }

  Quote _newQuote() => Quote(
        id: newId(),
        number: _composeNumber(''),
        date: _today(),
        object: '',
        client: '',
        status: QuoteStatus.draft,
        companyId: ref.read(currentCompanyProvider).id,
        sections: const [],
        rubriques: const [],
        signatures: [
          Signature(id: newId(), label: 'Le Technicien'),
          Signature(id: newId(), label: 'Le Client'),
        ],
      );

  /// Compose le numéro de devis selon le mode choisi en réglages :
  /// - par défaut : « PRÉFIXE-ANNÉE-SÉQUENCE » (ex. DV-2026-001) ;
  /// - « par objet » : « PRÉFIXE-OBJET » (l'objet remplace année-séquence).
  String _composeNumber(String object) {
    final company = ref.read(currentCompanyProvider);
    final prefix = company.quotePrefix.isEmpty ? 'DV' : company.quotePrefix;
    if (company.quoteNumberByObject) {
      final obj = object.trim();
      return obj.isEmpty ? prefix : '$prefix-$obj';
    }
    final year = DateTime.now().year;
    final seq = (_repo.getAll().length + 1).toString().padLeft(3, '0');
    return '$prefix-$year-$seq';
  }

  String _today() {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '${now.year}-$m-$d';
  }
}

/// Provider famille (un contrôleur par `quoteId`), auto-disposé à la sortie
/// de l'écran.
final quoteEditorControllerProvider = NotifierProvider.autoDispose
    .family<QuoteEditorController, QuoteEditorState, String>(
        QuoteEditorController.new);
