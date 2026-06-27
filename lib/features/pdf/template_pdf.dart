import 'dart:typed_data';

import 'package:dato/core/network/api_client.dart';
import 'package:dato/core/utils/dates.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/utils/montant_en_lettres.dart';
import 'package:dato/features/pdf/quote_pdf.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

/// Aplatit le devis (sections + rubriques) en lignes de tableau pré-formatées,
/// telles qu'elles doivent apparaître dans le tableau du modèle Word.
///
/// Le backend ne connaît pas la structure métier du devis : il reçoit ces
/// lignes « sémantiques » et les place dans les bonnes colonnes du template.
///
/// Reflète fidèlement le rendu du tableau de [buildQuotePdf] (`_table`).
List<Map<String, dynamic>> buildTemplateRows(Quote quote) {
  final rows = <Map<String, dynamic>>[];

  String intQty(double v) => v.round().toString();

  // ── Sections ──────────────────────────────────────────────────────────────
  for (final sec in quote.sections) {
    // En-tête de section (optionnelle) : ligne span sans montant.
    if (sec.hasVisibleTitle) {
      rows.add({
        'kind': 'span',
        'label': sec.title.toUpperCase(),
        'amount': '',
        'bold': true,
      });
    }
    for (final l in sec.lines) {
      rows.add({
        'kind': 'line',
        'designation': l.designation,
        'qty': intQty(l.qty),
        'pu': formatMoney(l.pu),
        'pt': formatMoney(l.pt),
      });
    }
    // Sous-total de section : utile dès qu'il y a plusieurs sections ou des
    // rubriques (sinon il ferait doublon avec le total général).
    if (quote.sections.length > 1 || quote.rubriques.isNotEmpty) {
      final label = RegExp('total', caseSensitive: false).hasMatch(sec.title)
          ? sec.title.toUpperCase()
          : 'Total ${sec.title}'.toUpperCase();
      rows.add({
        'kind': 'span',
        'label': label,
        'amount': formatMoney(sec.total),
        'bold': true,
      });
    }
  }

  // ── Rubriques (forfait / formule) ───────────────────────────────────────────
  for (final rub in quote.rubriques) {
    if (rub.lines.length <= 1) {
      final l = rub.lines.isNotEmpty ? rub.lines.first : null;
      final extra = (l != null &&
              l.mode == RubriqueMode.formula &&
              (l.sublabel ?? '').isNotEmpty)
          ? ' - ${l.sublabel}'
          : '';
      rows.add({
        'kind': 'span',
        'label': '${rub.label}$extra'.toUpperCase(),
        'amount': formatMoney(rub.total),
        'bold': true,
      });
    } else {
      for (var i = 0; i < rub.lines.length; i++) {
        final l = rub.lines[i];
        final mid = (l.sublabel ?? '').isNotEmpty
            ? l.sublabel!
            : (l.mode == RubriqueMode.forfait
                ? 'Forfait'
                : '${(l.a ?? 0).round()} × ${(l.b ?? 0).round()}');
        final desig = i == 0 ? '${rub.label.toUpperCase()} — $mid' : mid;
        rows.add({
          'kind': 'line',
          'designation': desig,
          'qty': '',
          'pu': '',
          'pt': formatMoney(l.total),
        });
      }
    }
  }

  // ── Total général ───────────────────────────────────────────────────────────
  // `strong` : ligne mise en avant (fond bleu foncé, texte blanc) côté backend.
  rows.add({
    'kind': 'span',
    'label': 'TOTAL GÉNÉRAL',
    'amount': formatMoney(quote.grandTotal),
    'bold': true,
    'strong': true,
  });

  return rows;
}

/// Construit le corps JSON pour `POST /api/quotes/pdf`.
///
/// Inclut, en plus des lignes du tableau, tout ce qu'il faut pour reconstruire
/// le corps complet du devis dans un template « papèterie » (en-tête/pied de
/// page Word seuls) : date, titre, client, montant en lettres, NB, signatures.
Map<String, dynamic> templatePdfPayload(Quote quote, Company company) {
  final city = company.city.trim();
  final cityDate = city.isNotEmpty
      ? '$city, le ${frenchLongDate(quote.date)}'
      : 'Le ${frenchLongDate(quote.date)}';
  return {
    'number': quote.number,
    'cityDate': cityDate,
    'title':
        'Devis estimatif quantitatif pour ${quote.object}'.toUpperCase(),
    'client': quote.client,
    'rows': buildTemplateRows(quote),
    'amountInWords': montantEnLettres(quote.grandTotal).toUpperCase(),
    'note': quote.note ?? '',
    'signatures': quote.signatures.map((s) => s.label).toList(),
  };
}

/// Retourne les octets du PDF du devis.
///
/// - Si l'entreprise a un modèle Word (`company.hasTemplate`), le PDF est
///   généré côté backend (en-tête / pied de page du Word préservés).
/// - Sinon — ou en cas d'échec backend — on retombe sur le rendu local par
///   défaut ([buildQuotePdf]).
Future<Uint8List> resolveQuotePdf({
  required ApiClient apiClient,
  required Quote quote,
  required Company company,
}) async {
  if (company.hasTemplate) {
    try {
      final bytes =
          await apiClient.generateTemplatePdf(templatePdfPayload(quote, company));
      if (bytes.isNotEmpty) return Uint8List.fromList(bytes);
    } catch (_) {
      // Échec backend (modèle introuvable, Word absent…) → rendu local.
    }
  }
  return buildQuotePdf(quote: quote, company: company);
}
