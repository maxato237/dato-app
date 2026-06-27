import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/app_network_image.dart';
import 'package:dato/core/utils/dates.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/utils/montant_en_lettres.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

/// Rendu « document » du devis, fidèle au gabarit A4 (crédible en N&B).
/// Réutilisé par l'aperçu (Phase 3) et la vue publique (Phase 6).
class QuoteDocument extends StatelessWidget {
  const QuoteDocument({
    super.key,
    required this.company,
    required this.quote,
    this.compact = false,
  });

  final Company company;
  final Quote quote;
  final bool compact;

  // Palette du document (proche de la maquette, lisible en noir & blanc).
  static const _docBorder = Color(0xFFC9D2DC);
  static const _lineBorder = AppColors.border;
  static const _headBg = AppColors.ink100;
  static const _subBg = Color(0xFFEEF3EE);

  static const int _desFlex = 46;
  static const int _qtyFlex = 12;
  static const int _puFlex = 20;
  static const int _ptFlex = 22;

  double get _fs => compact ? 0.92 : 1.0;

  @override
  Widget build(BuildContext context) {
    final total = quote.grandTotal;
    final pad = compact ? 20.0 : 30.0;
    final padV = compact ? 22.0 : 34.0;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: padV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _companyHeader(),
          SizedBox(height: 18 * _fs),
          // Ville, le <date>
          Align(
            alignment: Alignment.centerRight,
            child: Text.rich(
              TextSpan(
                text: '${company.city}, le ',
                children: [
                  TextSpan(
                    text: frenchLongDate(quote.date),
                    style: const TextStyle(
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
              style: TextStyle(fontSize: 13 * _fs, color: AppColors.text),
            ),
          ),
          SizedBox(height: 14 * _fs),
          // Objet
          Center(
            child: Text(
              'Devis estimatif quantitatif pour ${quote.object}'
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: _head(context).copyWith(
                fontSize: 14 * _fs,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                height: 1.35,
              ),
            ),
          ),
          SizedBox(height: 16 * _fs),
          // DOIT
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'DOIT',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(text: ' : ${quote.client}'),
              ],
            ),
            style: TextStyle(
                fontSize: 13 * _fs,
                fontWeight: FontWeight.w700,
                color: AppColors.text),
          ),
          SizedBox(height: 14 * _fs),
          _table(context, total),
          SizedBox(height: 16 * _fs),
          // Montant en lettres
          Text.rich(
            TextSpan(
              text: 'Arrêté le présent devis à la somme de ',
              children: [
                TextSpan(
                  text: montantEnLettres(total).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13 * _fs,
              color: AppColors.text,
              height: 1.5,
            ),
          ),
          if ((quote.note ?? '').trim().isNotEmpty) ...[
            SizedBox(height: 12 * _fs),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: 'NB : ',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: quote.note!.trim()),
                ],
              ),
              style: TextStyle(fontSize: 12 * _fs, color: AppColors.textMuted),
            ),
          ],
          SizedBox(height: 34 * _fs),
          _signatures(),
          if (company.hasLocation) ...[
            SizedBox(height: 26 * _fs),
            _footerBanner(),
          ],
        ],
      ),
    );
  }

  TextStyle _head(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!;

  Widget _footerBanner() {
    // Bandeau coloré avec le texte de localisation (plus d'image de fond).
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12 * _fs),
      alignment: Alignment.center,
      child: Text(
        company.location,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13 * _fs,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _companyHeader() {
    // Pas d'image de fond — cadre bordé classique.
    final Widget inner = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (company.hasLogo) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AppNetworkImage(
                company.logoUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  company.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22 * _fs,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: 0.5,
                    height: 1.1,
                  ),
                ),
                if (company.activity.trim().isNotEmpty) ...[
                  SizedBox(height: 2 * _fs),
                  Text(
                    company.activity,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13 * _fs,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
                if (company.address.trim().isNotEmpty ||
                    company.phones.trim().isNotEmpty) ...[
                  SizedBox(height: 3 * _fs),
                  Text(
                    [
                      if (company.address.trim().isNotEmpty)
                        company.address.trim(),
                      if (company.phones.trim().isNotEmpty)
                        'Tél : ${company.phones.trim()}',
                    ].join(' — '),
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 11 * _fs, color: AppColors.textMuted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: inner,
    );
  }

  Widget _table(BuildContext context, double total) {
    final rows = <Widget>[
      _headerRow(context),
    ];

    for (final sec in quote.sections) {
      // En-tête de section (optionnelle) au-dessus des lignes.
      if (sec.hasVisibleTitle) {
        rows.add(_spanRow(sec.title.toUpperCase(), '',
            bg: _headBg, bold: true, head: true));
      }
      for (final l in sec.lines) {
        rows.add(_lineRow(l));
      }
      // Sous-total de section : utile dès qu'il y a plusieurs sections ou des
      // rubriques (sinon il ferait doublon avec le total général).
      if (quote.sections.length > 1 || quote.rubriques.isNotEmpty) {
        final label = RegExp('total', caseSensitive: false).hasMatch(sec.title)
            ? sec.title.toUpperCase()
            : 'Total ${sec.title}'.toUpperCase();
        rows.add(_spanRow(label, formatMoney(sec.total),
            bg: _subBg, bold: true));
      }
    }

    for (final rub in quote.rubriques) {
      if (rub.lines.length <= 1) {
        final l = rub.lines.isNotEmpty ? rub.lines.first : null;
        final extra = (l != null &&
                l.mode == RubriqueMode.formula &&
                (l.sublabel ?? '').isNotEmpty)
            ? ' — ${l.sublabel}'
            : '';
        rows.add(_spanRow(
          '${rub.label}$extra'.toUpperCase(),
          formatMoney(rub.total),
          bg: _subBg,
          bold: true,
        ));
      } else {
        for (var i = 0; i < rub.lines.length; i++) {
          final l = rub.lines[i];
          final mid = (l.sublabel ?? '').isNotEmpty
              ? l.sublabel!
              : (l.mode == RubriqueMode.forfait
                  ? 'Forfait'
                  : '${(l.a ?? 0).round()} × ${(l.b ?? 0).round()}');
          rows.add(_rubLineRow(
            i == 0 ? rub.label.toUpperCase() : '',
            mid,
            formatMoney(l.total),
          ));
        }
      }
    }

    rows.add(_spanRow('TOTAL GÉNÉRAL', formatMoney(total),
        bg: AppColors.ink, fg: Colors.white, bold: true, head: true));

    return Container(
      decoration: BoxDecoration(border: Border.all(color: _docBorder)),
      child: Column(children: rows),
    );
  }

  Widget _headerRow(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cell('Désignation',
              flex: _desFlex, head: true, align: TextAlign.center),
          _cell('Qté', flex: _qtyFlex, head: true, align: TextAlign.center),
          _cell('P.U', flex: _puFlex, head: true, align: TextAlign.center),
          _cell('P.T',
              flex: _ptFlex,
              head: true,
              align: TextAlign.center,
              rightBorder: false),
        ],
      ),
    );
  }

  Widget _lineRow(SectionLine l) {
    return _DocRow(
      bottom: _lineBorder,
      children: [
        _cell(l.designation, flex: _desFlex),
        _cell(_int(l.qty),
            flex: _qtyFlex, align: TextAlign.center, numeric: true),
        _cell(formatMoney(l.pu),
            flex: _puFlex, align: TextAlign.right, numeric: true),
        _cell(formatMoney(l.pt),
            flex: _ptFlex,
            align: TextAlign.right,
            numeric: true,
            rightBorder: false),
      ],
    );
  }

  Widget _spanRow(
    String label,
    String value, {
    Color? bg,
    Color? fg,
    bool bold = false,
    bool head = false,
  }) {
    return _DocRow(
      bottom: _docBorder,
      children: [
        _cell(label,
            flex: _desFlex + _qtyFlex + _puFlex,
            bg: bg,
            fg: fg,
            bold: bold,
            head: head,
            rightBorder: false),
        _cell(value,
            flex: _ptFlex,
            align: TextAlign.right,
            numeric: true,
            bg: bg,
            fg: fg,
            bold: bold,
            head: head,
            rightBorder: false),
      ],
    );
  }

  Widget _rubLineRow(String label, String mid, String value) {
    return _DocRow(
      bottom: _docBorder,
      children: [
        _cell(label,
            flex: _desFlex, bg: _subBg, bold: true, uppercase: true),
        _cell(mid,
            flex: _qtyFlex + _puFlex, bg: _subBg, rightBorder: false),
        _cell(value,
            flex: _ptFlex,
            align: TextAlign.right,
            numeric: true,
            bg: _subBg,
            bold: true,
            rightBorder: false),
      ],
    );
  }

  Widget _cell(
    String text, {
    required int flex,
    TextAlign align = TextAlign.left,
    bool head = false,
    bool numeric = false,
    bool bold = false,
    bool uppercase = false,
    Color? bg,
    Color? fg,
    bool rightBorder = true,
  }) {
    // Centrage vertical du texte dans la hauteur de la cellule (les cellules
    // sont étirées à la hauteur de ligne par IntrinsicHeight + stretch).
    final cellAlign = align == TextAlign.center
        ? Alignment.center
        : align == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft;
    return Expanded(
      flex: flex,
      child: Container(
        alignment: cellAlign,
        decoration: BoxDecoration(
          color: head && bg == null ? _headBg : bg,
          border: rightBorder
              ? const Border(right: BorderSide(color: _docBorder))
              : null,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: 10 * _fs, vertical: 7 * _fs),
        child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: (head ? 12 : 13) * _fs,
            height: 1.3,
            fontWeight: (head || bold) ? FontWeight.w700 : FontWeight.w400,
            letterSpacing: head ? 0.4 : 0,
            color: fg ?? (head && bg == null ? AppColors.ink : AppColors.text),
            fontFeatures:
                numeric ? const [FontFeature.tabularFigures()] : null,
          ),
        ),
      ),
    );
  }

  Widget _signatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in quote.signatures)
          Expanded(
            child: Column(
              children: [
                Text(s.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13 * _fs, fontWeight: FontWeight.w600)),
                SizedBox(height: 40 * _fs),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.only(top: 4 * _fs),
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: AppColors.textLight)),
                  ),
                  child: Text('Signature',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10 * _fs, color: AppColors.textLight)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static String _int(double v) => v.round().toString();
}

/// Ligne de tableau avec bordure basse, cellules de hauteur égale.
class _DocRow extends StatelessWidget {
  const _DocRow({required this.children, required this.bottom});

  final List<Widget> children;
  final Color bottom;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: bottom))),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
