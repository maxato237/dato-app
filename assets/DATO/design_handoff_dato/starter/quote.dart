// ============================================================
// DATO — Modèles de domaine + calculs (cœur métier)
// Dossier conseillé : lib/features/quotes/domain/quote.dart
//
// Ici en Dart "pur" (immuable, sans dépendance) pour rester testable.
// Pour la persistance locale, créer des collections Isar miroir dans
// data/local/models/ et mapper depuis/vers ces entités de domaine
// (ou annoter directement — voir ARCHITECTURE.md).
// ============================================================

enum QuoteStatus { draft, sent, accepted, refused }

enum RubriqueMode { forfait, formula }

class SectionLine {
  final String id;
  final String designation;
  final double qty;
  final double pu;

  const SectionLine({
    required this.id,
    required this.designation,
    required this.qty,
    required this.pu,
  });

  double get pt => qty * pu;

  SectionLine copyWith({String? designation, double? qty, double? pu}) =>
      SectionLine(
        id: id,
        designation: designation ?? this.designation,
        qty: qty ?? this.qty,
        pu: pu ?? this.pu,
      );
}

class Section {
  final String id;
  final String title;
  final List<SectionLine> lines;

  const Section({required this.id, required this.title, required this.lines});

  /// Sous-total = Σ (qty × pu)
  double get total => lines.fold(0.0, (s, l) => s + l.pt);

  Section copyWith({String? title, List<SectionLine>? lines}) =>
      Section(id: id, title: title ?? this.title, lines: lines ?? this.lines);
}

class RubriqueLine {
  final String id;
  final RubriqueMode mode;
  final String? sublabel; // libellé optionnel (ex. "1500 × 40", "Planches")
  final double? amount; // mode forfait
  final double? a; // mode formula
  final double? b; // mode formula

  const RubriqueLine({
    required this.id,
    required this.mode,
    this.sublabel,
    this.amount,
    this.a,
    this.b,
  });

  /// Forfait : montant direct. Formule : a × b.
  double get total => mode == RubriqueMode.forfait
      ? (amount ?? 0)
      : (a ?? 0) * (b ?? 0);

  RubriqueLine copyWith({
    RubriqueMode? mode,
    String? sublabel,
    double? amount,
    double? a,
    double? b,
  }) =>
      RubriqueLine(
        id: id,
        mode: mode ?? this.mode,
        sublabel: sublabel ?? this.sublabel,
        amount: amount ?? this.amount,
        a: a ?? this.a,
        b: b ?? this.b,
      );
}

class Rubrique {
  final String id;
  final String label; // ex. "Transport", "Usinage", "Main d'œuvre"
  final List<RubriqueLine> lines;

  const Rubrique({required this.id, required this.label, required this.lines});

  /// Total rubrique = Σ des lignes.
  double get total => lines.fold(0.0, (s, l) => s + l.total);

  Rubrique copyWith({String? label, List<RubriqueLine>? lines}) =>
      Rubrique(id: id, label: label ?? this.label, lines: lines ?? this.lines);
}

class Signature {
  final String id;
  final String label;
  const Signature({required this.id, required this.label});
}

class Quote {
  final String id;
  final String number; // "DV-2026-014" (format paramétrable)
  final String date; // ISO yyyy-MM-dd
  final String object;
  final String client; // OBLIGATOIRE (DOIT)
  final QuoteStatus status;
  final List<Section> sections;
  final List<Rubrique> rubriques;
  final List<Signature> signatures;
  final String? note;
  final String companyId;

  const Quote({
    required this.id,
    required this.number,
    required this.date,
    required this.object,
    required this.client,
    required this.status,
    required this.sections,
    required this.rubriques,
    required this.signatures,
    required this.companyId,
    this.note,
  });

  /// Total général = Σ sous-totaux sections + Σ totaux rubriques.
  double get grandTotal {
    final a = sections.fold(0.0, (s, sec) => s + sec.total);
    final b = rubriques.fold(0.0, (s, r) => s + r.total);
    return a + b;
  }

  bool get isValid => client.trim().isNotEmpty;
}
