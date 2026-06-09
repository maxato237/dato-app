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

  double get total => lines.fold(0.0, (s, l) => s + l.pt);

  Section copyWith({String? title, List<SectionLine>? lines}) =>
      Section(id: id, title: title ?? this.title, lines: lines ?? this.lines);
}

class RubriqueLine {
  final String id;
  final RubriqueMode mode;
  final String? sublabel;
  final double? amount;
  final double? a;
  final double? b;

  const RubriqueLine({
    required this.id,
    required this.mode,
    this.sublabel,
    this.amount,
    this.a,
    this.b,
  });

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
  final String label;
  final List<RubriqueLine> lines;

  const Rubrique({required this.id, required this.label, required this.lines});

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
  final String number;
  final String date;
  final String object;
  final String client;
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

  double get grandTotal {
    final a = sections.fold(0.0, (s, sec) => s + sec.total);
    final b = rubriques.fold(0.0, (s, r) => s + r.total);
    return a + b;
  }

  bool get isValid => client.trim().isNotEmpty;

  Quote copyWith({
    String? number,
    String? date,
    String? object,
    String? client,
    QuoteStatus? status,
    List<Section>? sections,
    List<Rubrique>? rubriques,
    List<Signature>? signatures,
    String? note,
  }) =>
      Quote(
        id: id,
        number: number ?? this.number,
        date: date ?? this.date,
        object: object ?? this.object,
        client: client ?? this.client,
        status: status ?? this.status,
        sections: sections ?? this.sections,
        rubriques: rubriques ?? this.rubriques,
        signatures: signatures ?? this.signatures,
        companyId: companyId,
        note: note ?? this.note,
      );
}
