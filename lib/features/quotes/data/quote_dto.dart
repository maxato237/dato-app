import 'package:dato/core/utils/id.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

/// (Dé)sérialisation des devis entre le domaine riche de l'app
/// (sections + rubriques forfait/formule) et le backend Flask.
///
/// Deux représentations cohabitent côté serveur :
/// - `document_json` : snapshot **fidèle** du devis riche → source de la vue
///   publique ; rejoué tel quel par [quoteFromDocumentJson].
/// - `items[]` (plat) : aplatissement pour les listes/stats serveur.

/// Statut app → statut backend (`refused` ↦ `rejected`).
String quoteStatusToServer(QuoteStatus s) => switch (s) {
      QuoteStatus.draft => 'draft',
      QuoteStatus.sent => 'sent',
      QuoteStatus.accepted => 'accepted',
      QuoteStatus.refused => 'rejected',
    };

/// Statut backend → statut app (`rejected` ↦ `refused`).
QuoteStatus quoteStatusFromServer(String? s) => switch (s) {
      'sent' => QuoteStatus.sent,
      'accepted' => QuoteStatus.accepted,
      'rejected' || 'refused' => QuoteStatus.refused,
      _ => QuoteStatus.draft,
    };

double _toDouble(Object? v) => v is num ? v.toDouble() : 0.0;
double? _toDoubleOrNull(Object? v) => v is num ? v.toDouble() : null;

extension QuoteServerCodec on Quote {
  /// Snapshot JSON complet du devis riche (rejouable à l'identique).
  Map<String, dynamic> toDocumentJson() => {
        'id': id,
        'number': number,
        'date': date,
        'object': object,
        'client': client,
        'status': quoteStatusToServer(status),
        'note': note,
        'sections': [
          for (final s in sections)
            {
              'id': s.id,
              'title': s.title,
              'showTitle': s.showTitle,
              'lines': [
                for (final l in s.lines)
                  {
                    'id': l.id,
                    'designation': l.designation,
                    'qty': l.qty,
                    'pu': l.pu,
                  },
              ],
            },
        ],
        'rubriques': [
          for (final r in rubriques)
            {
              'id': r.id,
              'label': r.label,
              'lines': [
                for (final l in r.lines)
                  {
                    'id': l.id,
                    'mode': l.mode.name,
                    'sublabel': l.sublabel,
                    'amount': l.amount,
                    'a': l.a,
                    'b': l.b,
                  },
              ],
            },
        ],
        'signatures': [
          for (final s in signatures) {'id': s.id, 'label': s.label},
        ],
        'grandTotal': grandTotal,
      };

  /// Aplatissement en lignes plates pour les colonnes/stats du backend.
  /// Chaque ligne de section ou de rubrique devient un `item` dont le produit
  /// `quantity × unit_price` reconstitue son total.
  List<Map<String, dynamic>> toFlatItems() {
    final items = <Map<String, dynamic>>[];
    var order = 0;
    String desc(String s) => s.trim().isEmpty ? '—' : s.trim();

    for (final s in sections) {
      for (final l in s.lines) {
        items.add({
          'description': desc(l.designation),
          'quantity': l.qty,
          'unit_price': l.pu,
          'order_index': order++,
        });
      }
    }
    for (final r in rubriques) {
      for (final l in r.lines) {
        final label = [r.label, l.sublabel ?? '']
            .where((e) => e.trim().isNotEmpty)
            .join(' — ');
        if (l.mode == RubriqueMode.forfait) {
          items.add({
            'description': desc(label),
            'quantity': 1,
            'unit_price': l.amount ?? 0,
            'order_index': order++,
          });
        } else {
          items.add({
            'description': desc(label),
            'quantity': l.a ?? 0,
            'unit_price': l.b ?? 0,
            'order_index': order++,
          });
        }
      }
    }
    return items;
  }

  /// Corps pour `PUT /api/quotes/:id` (mise à jour ; sans `id`/`number`).
  Map<String, dynamic> toUpdateBody() => {
        'title': object.trim().isEmpty ? number : object,
        'notes': note,
        'tax_rate': 0,
        'document_json': toDocumentJson(),
        'items': toFlatItems(),
      };

  /// Corps pour `POST /api/quotes` (création idempotente ; `id`/`number` fournis).
  Map<String, dynamic> toCreateBody() => {
        'id': id,
        'number': number,
        ...toUpdateBody(),
      };
}

/// Reconstruit un [Quote] riche depuis un snapshot `document_json`.
Quote quoteFromDocumentJson(Map<String, dynamic> j,
    {required String companyId}) {
  List<Map<String, dynamic>> list(Object? v) =>
      (v as List? ?? const []).map((e) => (e as Map).cast<String, dynamic>()).toList();

  return Quote(
    id: j['id']?.toString() ?? '',
    number: j['number']?.toString() ?? '',
    date: j['date']?.toString() ?? '',
    object: j['object']?.toString() ?? '',
    client: j['client']?.toString() ?? '',
    status: quoteStatusFromServer(j['status']?.toString()),
    note: j['note']?.toString(),
    companyId: companyId,
    sections: [
      for (final s in list(j['sections']))
        Section(
          id: s['id']?.toString() ?? newId(),
          title: s['title']?.toString() ?? '',
          showTitle: s['showTitle'] as bool? ?? true,
          lines: [
            for (final l in list(s['lines']))
              SectionLine(
                id: l['id']?.toString() ?? newId(),
                designation: l['designation']?.toString() ?? '',
                qty: _toDouble(l['qty']),
                pu: _toDouble(l['pu']),
              ),
          ],
        ),
    ],
    rubriques: [
      for (final r in list(j['rubriques']))
        Rubrique(
          id: r['id']?.toString() ?? newId(),
          label: r['label']?.toString() ?? '',
          lines: [
            for (final l in list(r['lines']))
              RubriqueLine(
                id: l['id']?.toString() ?? newId(),
                mode: l['mode'] == 'formula'
                    ? RubriqueMode.formula
                    : RubriqueMode.forfait,
                sublabel: l['sublabel']?.toString(),
                amount: _toDoubleOrNull(l['amount']),
                a: _toDoubleOrNull(l['a']),
                b: _toDoubleOrNull(l['b']),
              ),
          ],
        ),
    ],
    signatures: [
      for (final s in list(j['signatures']))
        Signature(
          id: s['id']?.toString() ?? newId(),
          label: s['label']?.toString() ?? '',
        ),
    ],
  );
}

/// Repli : reconstruit un devis depuis la représentation **plate** du backend
/// (devis créés via l'API sans snapshot riche).
Quote quoteFromFlatJson(Map<String, dynamic> data,
    {required String companyId}) {
  final lines = [
    for (final m in (data['items'] as List? ?? const []))
      SectionLine(
        id: (m as Map)['id']?.toString() ?? newId(),
        designation: m['description']?.toString() ?? '',
        qty: _toDouble(m['quantity']),
        pu: _toDouble(m['unit_price']),
      ),
  ];
  final client = data['client'];
  final clientName =
      client is Map ? (client['name']?.toString() ?? '') : '';

  return Quote(
    id: data['id']?.toString() ?? '',
    number: data['number']?.toString() ?? '',
    date: (data['created_at']?.toString() ?? '').split('T').first,
    object: data['title']?.toString() ?? '',
    client: clientName,
    status: quoteStatusFromServer(data['status']?.toString()),
    note: data['notes']?.toString(),
    companyId: companyId,
    sections: [
      Section(id: newId(), title: 'Désignations', showTitle: false, lines: lines),
    ],
    rubriques: const [],
    signatures: const [
      Signature(id: 'sg1', label: 'Le Technicien'),
      Signature(id: 'sg2', label: 'Le Client'),
    ],
  );
}

/// Reconstruit un devis depuis la réponse `GET /api/quotes/:id` (devis de
/// l'utilisateur authentifié) : privilégie le snapshot `document_json`, repli
/// sur les lignes plates.
Quote quoteFromServerDict(Map<String, dynamic> data,
    {required String companyId}) {
  final doc = (data['document_json'] as Map?)?.cast<String, dynamic>();
  return doc != null
      ? quoteFromDocumentJson(doc, companyId: companyId)
      : quoteFromFlatJson(data, companyId: companyId);
}

/// Vue publique d'un devis (devis + en-tête entreprise), telle que renvoyée
/// par `GET /p/:token`.
class PublicQuote {
  final Quote quote;
  final Company company;
  const PublicQuote({required this.quote, required this.company});

  factory PublicQuote.fromJson(Map<String, dynamic> data) {
    final companyJson =
        (data['company'] as Map?)?.cast<String, dynamic>() ?? const {};
    final company = Company.fromJson(companyJson);
    final doc = (data['document_json'] as Map?)?.cast<String, dynamic>();
    final quote = doc != null
        ? quoteFromDocumentJson(doc, companyId: company.id)
        : quoteFromFlatJson(data, companyId: company.id);
    return PublicQuote(quote: quote, company: company);
  }
}
