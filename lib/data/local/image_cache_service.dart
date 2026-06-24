import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:dato/core/network/api_client.dart';
import 'package:dato/core/network/network_providers.dart';

import 'isar_service.dart';
import 'models/binary_asset.dart';

/// Cache local des images (logo, photos) par URL, dans Isar, pour que les
/// documents de devis s'affichent **hors-ligne**.
class ImageCacheService {
  ImageCacheService(this._isar, this._api);

  final Isar? _isar;
  final ApiClient _api;

  /// Octets en cache pour [url], ou `null` si absent / Isar indisponible.
  Uint8List? cached(String url) {
    final isar = _isar;
    if (isar == null || url.isEmpty) return null;
    final asset = isar.binaryAssets.getByUrlSync(url);
    return asset == null ? null : Uint8List.fromList(asset.bytes);
  }

  /// Télécharge [url] et met les octets en cache. No-op si déjà présent, si
  /// Isar est indisponible, ou en cas d'échec réseau (réessai ultérieur).
  Future<void> ensureCached(String url) async {
    final isar = _isar;
    if (isar == null || url.isEmpty) return;
    if (isar.binaryAssets.getByUrlSync(url) != null) return;
    try {
      final bytes = await _api.download(url);
      if (bytes.isEmpty) return;
      await isar.writeTxn(() => isar.binaryAssets.putByUrl(
            BinaryAsset()
              ..url = url
              ..bytes = bytes
              ..cachedAt = DateTime.now(),
          ));
    } catch (_) {
      // Hors-ligne ou URL injoignable : on réessaiera au prochain affichage.
    }
  }
}

final imageCacheServiceProvider = Provider<ImageCacheService>(
  (ref) => ImageCacheService(
    ref.watch(isarProvider),
    ref.watch(apiClientProvider),
  ),
);
