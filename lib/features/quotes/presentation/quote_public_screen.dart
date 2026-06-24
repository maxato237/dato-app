import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';
import 'package:dato/features/quotes/data/quote_dto.dart';
import 'package:dato/features/quotes/widgets/quote_document.dart';

/// Charge la vue publique d'un devis via son token de partage (sans auth).
final publicQuoteProvider =
    FutureProvider.autoDispose.family<PublicQuote, String>(
  (ref, token) => ref.watch(quoteRemoteDataSourceProvider).fetchPublic(token),
);

/// Vue publique d'un devis, ouverte via deep link `/p/:token`.
/// Accessible sans authentification ; renvoie un état « indisponible » si le
/// lien est inconnu ou révoqué (404).
class QuotePublicScreen extends ConsumerWidget {
  const QuotePublicScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(publicQuoteProvider(token));
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        elevation: 0,
        title: const Text('Devis'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _Unavailable(),
        data: (pq) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Material(
                elevation: 1,
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadii.md),
                clipBehavior: Clip.antiAlias,
                child: QuoteDocument(company: pq.company, quote: pq.quote),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.link_off_outlined,
                size: 48, color: AppColors.textLight),
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Ce devis n’est plus disponible',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s2),
            const Text(
              'Le lien de partage est introuvable ou a été révoqué.',
              style: TextStyle(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
