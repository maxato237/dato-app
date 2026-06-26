import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' show networkImage;

import 'package:dato/core/utils/dates.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/utils/montant_en_lettres.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

// Palette (identique au gabarit ; lisible en noir & blanc).
const _ink = PdfColor.fromInt(0xFF1B4965);
const _headBg = PdfColor.fromInt(0xFFE7EEF3);
const _subBg = PdfColor.fromInt(0xFFEEF3EE);
const _docBorder = PdfColor.fromInt(0xFFC9D2DC);
const _lineBorder = PdfColor.fromInt(0xFFE3E8EE);
const _text = PdfColor.fromInt(0xFF101828);
const _muted = PdfColor.fromInt(0xFF475467);
const _light = PdfColor.fromInt(0xFF98A2B3);

const int _desFlex = 46;
const int _qtyFlex = 12;
const int _puFlex = 20;
const int _ptFlex = 22;

/// Construit le PDF A4 d'un devis (1 page), fidèle à `Gabarit PDF A4.html`.
///
/// Utilise la police Inter (bundlée dans les assets) pour un rendu correct
/// de tous les caractères Unicode, y compris les ligatures françaises : œ, æ…
Future<Uint8List> buildQuotePdf({
  required Quote quote,
  required Company company,
}) async {
  // Charger Inter depuis les assets pour supporter œ, æ et tous les accents.
  final ByteData fontData = await rootBundle.load('assets/fonts/Inter.ttf');
  final pw.Font interFont = pw.Font.ttf(fontData);

  final doc = pw.Document(
    title: quote.number,
    author: company.name,
    // Thème global : Inter remplace Helvetica sur tout le document.
    theme: pw.ThemeData.withFont(
      base: interFont,
      bold: interFont, // même fichier — le package gère la simulation gras
      italic: interFont,
      boldItalic: interFont,
    ),
  );
  final total = quote.grandTotal;

  // Récupération réseau du logo (échec silencieux).
  final logoImg = company.hasLogo ? await _tryImage(company.logoUrl) : null;

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(34),
      // MultiPage (et non Page) : le contenu long se pagine au lieu d'être
      // rogné — le pied de page (localisation) reste toujours visible.
      build: (context) => [
          _header(company, logoImg),
          pw.SizedBox(height: 18),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.RichText(
              text: pw.TextSpan(
                text: '${company.city}, le ',
                style: const pw.TextStyle(fontSize: 13, color: _text),
                children: [
                  pw.TextSpan(
                    text: frenchLongDate(quote.date),
                    style: const pw.TextStyle(
                        decoration: pw.TextDecoration.underline),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Center(
            child: pw.Text(
              'Devis estimatif quantitatif pour ${quote.object}'
                  .toUpperCase(),
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline,
                lineSpacing: 2,
              ),
            ),
          ),
          pw.SizedBox(height: 16),
          pw.RichText(
            text: pw.TextSpan(
              style: pw.TextStyle(
                  fontSize: 13, fontWeight: pw.FontWeight.bold, color: _text),
              children: [
                const pw.TextSpan(
                  text: 'DOIT',
                  style:
                      pw.TextStyle(decoration: pw.TextDecoration.underline),
                ),
                pw.TextSpan(text: ' : ${quote.client}'),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          // Lignes étalées au premier niveau : MultiPage peut paginer entre
          // elles (bordures portées par chaque ligne, cf. _row).
          ..._tableRows(quote, total),
          pw.SizedBox(height: 16),
          pw.RichText(
            text: pw.TextSpan(
              style: pw.TextStyle(
                  fontSize: 13, fontStyle: pw.FontStyle.italic, color: _text),
              children: [
                const pw.TextSpan(
                    text: 'Arrêté le présent devis à la somme de '),
                pw.TextSpan(
                  text: montantEnLettres(total).toUpperCase(),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                const pw.TextSpan(text: '.'),
              ],
            ),
          ),
          if ((quote.note ?? '').trim().isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.RichText(
              text: pw.TextSpan(
                style: const pw.TextStyle(fontSize: 12, color: _muted),
                children: [
                  pw.TextSpan(
                      text: 'NB : ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.TextSpan(text: quote.note!.trim()),
                ],
              ),
            ),
          ],
          pw.SizedBox(height: 34),
          _signatures(quote),
          if (company.hasLocation) ...[
            pw.SizedBox(height: 26),
            _footerBanner(company),
          ],
      ],
    ),
  );

  return doc.save();
}

Future<pw.ImageProvider?> _tryImage(String url) async {
  try {
    return await networkImage(url);
  } catch (_) {
    return null;
  }
}

pw.Widget _footerBanner(Company company) {
  // Bandeau coloré avec le texte de localisation (plus d'image de fond).
  return pw.Container(
    width: double.infinity,
    decoration: const pw.BoxDecoration(
      color: _ink,
      borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
    ),
    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    alignment: pw.Alignment.center,
    child: pw.Text(
      company.location,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 13,
        fontWeight: pw.FontWeight.bold,
        lineSpacing: 1.5,
      ),
    ),
  );
}

pw.Widget _header(Company company, [pw.ImageProvider? logo]) {
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: _ink, width: 2),
      borderRadius: pw.BorderRadius.circular(6),
    ),
    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Logo affiché uniquement s'il a pu être chargé (sinon : texte seul).
        if (logo != null) ...[
          pw.ClipRRect(
            horizontalRadius: 8,
            verticalRadius: 8,
            child: pw.SizedBox(
              width: 52,
              height: 52,
              child: pw.Image(logo, fit: pw.BoxFit.cover),
            ),
          ),
          pw.SizedBox(width: 14),
        ],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(company.name,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: _ink,
                      letterSpacing: 0.5)),
              pw.SizedBox(height: 2),
              pw.Text(company.activity,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 3),
              pw.Text('${company.address} - Tél : ${company.phones}',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 11, color: _muted)),
            ],
          ),
        ),
      ],
    ),
  );
}

List<pw.Widget> _tableRows(Quote quote, double total) {
  final rows = <pw.Widget>[_headerRow()];

  for (final sec in quote.sections) {
    // En-tête de section (optionnelle) au-dessus des lignes.
    if (sec.hasVisibleTitle) {
      rows.add(_spanRow(sec.title.toUpperCase(), '', bg: _headBg));
    }
    for (final l in sec.lines) {
      rows.add(_row(bottom: _lineBorder, cells: [
        _cell(l.designation, flex: _desFlex),
        _cell(_int(l.qty),
            flex: _qtyFlex, align: pw.TextAlign.center),
        _cell(formatMoney(l.pu), flex: _puFlex, align: pw.TextAlign.right),
        _cell(formatMoney(l.pt),
            flex: _ptFlex, align: pw.TextAlign.right, rightBorder: false),
      ]));
    }
    // Sous-total de section : uniquement s'il y a au moins deux sections.
    if (quote.sections.length > 1) {
      final label = RegExp('total', caseSensitive: false).hasMatch(sec.title)
          ? sec.title.toUpperCase()
          : 'Total ${sec.title}'.toUpperCase();
      rows.add(_spanRow(label, formatMoney(sec.total), bg: _subBg));
    }
  }

  for (final rub in quote.rubriques) {
    if (rub.lines.length <= 1) {
      final l = rub.lines.isNotEmpty ? rub.lines.first : null;
      final extra = (l != null &&
              l.mode == RubriqueMode.formula &&
              (l.sublabel ?? '').isNotEmpty)
          ? ' - ${l.sublabel}'
          : '';
      rows.add(_spanRow(
          '${rub.label}$extra'.toUpperCase(), formatMoney(rub.total),
          bg: _subBg));
    } else {
      for (var i = 0; i < rub.lines.length; i++) {
        final l = rub.lines[i];
        final mid = (l.sublabel ?? '').isNotEmpty
            ? l.sublabel!
            : (l.mode == RubriqueMode.forfait
                ? 'Forfait'
                : '${(l.a ?? 0).round()} × ${(l.b ?? 0).round()}');
        rows.add(_row(bottom: _docBorder, cells: [
          _cell(i == 0 ? rub.label.toUpperCase() : '',
              flex: _desFlex, bg: _subBg, bold: true),
          _cell(mid, flex: _qtyFlex + _puFlex, bg: _subBg, rightBorder: false),
          _cell(formatMoney(l.total),
              flex: _ptFlex,
              align: pw.TextAlign.right,
              bg: _subBg,
              bold: true,
              rightBorder: false),
        ]));
      }
    }
  }

  rows.add(_spanRow('TOTAL GÉNÉRAL', formatMoney(total),
      bg: _ink, fg: PdfColors.white));

  return rows;
}

pw.Widget _headerRow() {
  return _row(bottom: _docBorder, top: true, cells: [
    _cell('Désignation', flex: _desFlex, head: true, align: pw.TextAlign.center),
    _cell('Qté', flex: _qtyFlex, head: true, align: pw.TextAlign.center),
    _cell('P.U', flex: _puFlex, head: true, align: pw.TextAlign.center),
    _cell('P.T',
        flex: _ptFlex,
        head: true,
        align: pw.TextAlign.center,
        rightBorder: false),
  ]);
}

pw.Widget _spanRow(String label, String value,
    {required PdfColor bg, PdfColor? fg}) {
  return _row(bottom: _docBorder, cells: [
    _cell(label,
        flex: _desFlex + _qtyFlex + _puFlex,
        bg: bg,
        fg: fg,
        bold: true,
        rightBorder: false),
    _cell(value,
        flex: _ptFlex,
        align: pw.TextAlign.right,
        bg: bg,
        fg: fg,
        bold: true,
        rightBorder: false),
  ]);
}

pw.Widget _row({
  required List<pw.Widget> cells,
  required PdfColor bottom,
  bool top = false,
}) {
  // Bordures gauche/droite portées par chaque ligne (le cadre extérieur n'est
  // plus un Container englobant, pour permettre la pagination par MultiPage).
  return pw.Container(
    decoration: pw.BoxDecoration(
      border: pw.Border(
        left: const pw.BorderSide(color: _docBorder),
        right: const pw.BorderSide(color: _docBorder),
        bottom: pw.BorderSide(color: bottom),
        top: top
            ? const pw.BorderSide(color: _docBorder)
            : pw.BorderSide.none,
      ),
    ),
    // Pas de `stretch` ici : le paquet `pdf` n'a pas d'IntrinsicHeight, et
    // étirer sur une hauteur non bornée fait s'effondrer le tableau.
    // `center` centre le texte verticalement quand une cellule (ex. une
    // désignation longue) passe sur deux lignes.
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: cells,
    ),
  );
}

pw.Widget _cell(
  String text, {
  required int flex,
  pw.TextAlign align = pw.TextAlign.left,
  bool head = false,
  bool bold = false,
  PdfColor? bg,
  PdfColor? fg,
  bool rightBorder = true,
}) {
  return pw.Expanded(
    flex: flex,
    child: pw.Container(
      decoration: pw.BoxDecoration(
        color: head && bg == null ? _headBg : bg,
        border: rightBorder
            ? const pw.Border(right: pw.BorderSide(color: _docBorder))
            : null,
      ),
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(
          fontSize: head ? 12 : 13,
          fontWeight:
              (head || bold) ? pw.FontWeight.bold : pw.FontWeight.normal,
          letterSpacing: head ? 0.4 : 0,
          color: fg ?? (head && bg == null ? _ink : _text),
        ),
      ),
    ),
  );
}

pw.Widget _signatures(Quote quote) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      for (final s in quote.signatures)
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text(s.label,
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 40),
              pw.Container(
                margin: const pw.EdgeInsets.symmetric(horizontal: 8),
                padding: const pw.EdgeInsets.only(top: 4),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: _light)),
                ),
                child: pw.Text('Signature',
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(fontSize: 10, color: _light)),
              ),
            ],
          ),
        ),
    ],
  );
}

String _int(double v) => v.round().toString();
