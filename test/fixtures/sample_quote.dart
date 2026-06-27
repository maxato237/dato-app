import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

/// Entreprise d'exemple (en-tête des documents de devis).
Company sampleCompany() => const Company(
      id: 'demo-company',
      name: 'ATELIER DÉMO',
      activity: 'MENUISERIE GÉNÉRALE',
      address: 'BP : 0000',
      phones: '600 00 00 00 / 611 00 00 00',
      city: 'Yaoundé',
    );

/// Devis d'exemple **déterministe** (ids fixes) réutilisé par les widget tests
/// et la golden de l'éditeur. Données fictives, simplifiées pour des
/// assertions stables.
///
/// Repères de calcul à la création :
/// - l1 Planches : Qté 1 × 6 000  = 6 000   (le test passe Qté à 60 → 360 000)
/// - l2 Colle    : Qté 10 × 3 000 = 30 000
/// - l3 Bandes   : Qté 2 × 24 000 = 48 000
/// - r1 Usinage  : 1 500 × 40      = 60 000  (formule, ligne `rl-form`)
/// - r2 Transport: forfait         = 50 000  (ligne `rl-forf`)
Quote sampleQuote() => const Quote(
      id: 'fix',
      number: 'DV-2026-014',
      date: '2026-05-12',
      object: 'Fabrication de 40 chaises',
      client: 'Client Démo',
      status: QuoteStatus.draft,
      companyId: 'demo-company',
      sections: [
        Section(id: 's1', title: 'Matériel', lines: [
          SectionLine(id: 'l1', designation: 'Planches', qty: 1, pu: 6000),
          SectionLine(id: 'l2', designation: 'Litres de colle', qty: 10, pu: 3000),
          SectionLine(id: 'l3', designation: 'Bandes à poncer', qty: 2, pu: 24000),
        ]),
      ],
      rubriques: [
        Rubrique(id: 'r1', label: 'Usinage', lines: [
          RubriqueLine(id: 'rl-form', mode: RubriqueMode.formula, a: 1500, b: 40),
        ]),
        Rubrique(id: 'r2', label: 'Transport', lines: [
          RubriqueLine(id: 'rl-forf', mode: RubriqueMode.forfait, amount: 50000),
        ]),
      ],
      signatures: [
        Signature(id: 'sg1', label: 'Le Technicien'),
        Signature(id: 'sg2', label: 'Le Client'),
      ],
    );
