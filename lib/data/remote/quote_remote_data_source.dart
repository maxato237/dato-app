import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/network/api_client.dart';
import 'package:dato/core/network/api_exception.dart';
import 'package:dato/core/network/network_providers.dart';
import 'package:dato/features/quotes/data/quote_dto.dart';
import 'package:dato/features/quotes/domain/quote.dart';

/// Accès distant aux devis (API Flask) — utilisé par la file de sync et la
/// vue publique. Toutes les écritures sont **idempotentes** côté backend.
class QuoteRemoteDataSource {
  final ApiClient _api;
  const QuoteRemoteDataSource(this._api);

  /// Pousse le devis vers le serveur (création ou mise à jour).
  ///
  /// - Brouillon / envoyé : `PUT` d'abord (cas courant après la 1ʳᵉ sync),
  ///   repli `POST` si le devis n'existe pas encore (404).
  /// - Accepté / refusé : le backend verrouille la modification du contenu
  ///   (409 sur `PUT`) ; on garantit l'existence puis on ne pousse que le statut.
  Future<void> upsert(Quote quote) async {
    if (quote.status == QuoteStatus.accepted ||
        quote.status == QuoteStatus.refused) {
      await _ensureExists(quote);
      await _patchStatus(quote.id, quoteStatusToServer(quote.status));
      return;
    }

    try {
      await _api.put('/api/quotes/${quote.id}', body: quote.toUpdateBody());
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        await _create(quote);
      } else {
        rethrow;
      }
    }
    if (quote.status == QuoteStatus.sent) {
      await _patchStatus(quote.id, 'sent');
    }
  }

  Future<void> delete(String id) => _api.delete('/api/quotes/$id');

  /// Liste légère des devis du serveur (sans `document_json`) — sert à détecter
  /// ce qui manque localement avant un rechargement (pull/restore).
  Future<List<Map<String, dynamic>>> fetchSummaries() async {
    final body = await _api.get('/api/quotes');
    final list = body['data'] as List? ?? const [];
    return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  /// Devis complet (avec `document_json`) par id.
  Future<Quote> fetchOne(String id, {required String companyId}) async {
    final body = await _api.get('/api/quotes/$id');
    return quoteFromServerDict(
      body['data'] as Map<String, dynamic>,
      companyId: companyId,
    );
  }

  /// Vue publique d'un devis (sans authentification) via son token de partage.
  Future<PublicQuote> fetchPublic(String token) async {
    final body = await _api.get('/p/$token', auth: false);
    return PublicQuote.fromJson(body['data'] as Map<String, dynamic>);
  }

  /// Active le lien public et renvoie son URL partageable.
  Future<String> enableShare(String id) async {
    final body = await _api.post('/api/quotes/$id/share');
    return (body['data'] as Map<String, dynamic>)['public_url'] as String;
  }

  /// Régénère le lien (l'ancien devient définitivement invalide).
  Future<String> regenerateShare(String id) async {
    final body = await _api.post('/api/quotes/$id/share/regenerate');
    return (body['data'] as Map<String, dynamic>)['public_url'] as String;
  }

  /// Révoque le lien public (la vue publique renverra 404).
  Future<void> revokeShare(String id) => _api.delete('/api/quotes/$id/share');

  // ── interne ───────────────────────────────────────────────────────────────

  Future<void> _create(Quote q) async {
    // Un brouillon sans aucune ligne n'est jamais créé côté serveur (no-op) :
    // il le sera dès qu'il aura du contenu.
    if ((q.toFlatItems()).isEmpty) return;
    await _api.post('/api/quotes', body: q.toCreateBody());
  }

  Future<void> _ensureExists(Quote q) async {
    try {
      await _api.put('/api/quotes/${q.id}',
          body: {'title': q.object.trim().isEmpty ? q.number : q.object});
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        await _create(q);
      } else if (e.statusCode == 409) {
        // Déjà accepté/refusé côté serveur → existe, rien à corriger.
      } else {
        rethrow;
      }
    }
  }

  Future<void> _patchStatus(String id, String status) =>
      _api.patch('/api/quotes/$id/status', body: {'status': status});
}

final quoteRemoteDataSourceProvider = Provider<QuoteRemoteDataSource>(
  (ref) => QuoteRemoteDataSource(ref.watch(apiClientProvider)),
);
