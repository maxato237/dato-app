import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dato/features/settings/domain/company.dart';

class CompanyNotifier extends StateNotifier<Company> {
  CompanyNotifier()
      : super(const Company(
          id: 'demo-company',
          name: 'MILLENAIRE DECOR',
          activity: 'MENUISERIE GÉNÉRALE',
          address: 'BP : 705 YDE',
          phones: '674 70 20 37 / 695 42 93 71',
          city: 'Yaoundé',
          currency: 'FCFA',
        ));

  void update(Company company) => state = company;
}

/// Entreprise courante (en-tête des devis).
///
/// Lire avec `ref.watch(currentCompanyProvider)` → `Company`.
/// Écrire via `ref.read(currentCompanyProvider.notifier).update(company)`.
///
/// Seedée avec MILLENAIRE DECOR pour la démo. L'onboarding (Phase 5) et les
/// réglages (Phase 8) l'alimenteront via `.notifier.update(...)`.
final currentCompanyProvider =
    StateNotifierProvider<CompanyNotifier, Company>(
  (ref) => CompanyNotifier(),
);
