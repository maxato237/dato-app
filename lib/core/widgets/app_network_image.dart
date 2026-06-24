import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/data/local/image_cache_service.dart';

/// Image distante **offline-first** : affiche les octets en cache local s'ils
/// existent (Isar), sinon charge depuis le réseau et met en cache en arrière-
/// plan pour les prochains affichages hors-ligne.
class AppNetworkImage extends ConsumerStatefulWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final WidgetBuilder? errorBuilder;

  @override
  ConsumerState<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends ConsumerState<AppNetworkImage> {
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    final svc = ref.read(imageCacheServiceProvider);
    _bytes = svc.cached(widget.url);
    if (_bytes == null) {
      svc.ensureCached(widget.url).then((_) {
        if (!mounted) return;
        final b = svc.cached(widget.url);
        if (b != null) setState(() => _bytes = b);
      });
    }
  }

  Widget _error(BuildContext context) =>
      widget.errorBuilder?.call(context) ?? const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final bytes = _bytes;
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: (c, _, __) => _error(c),
      );
    }
    return Image.network(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (c, _, __) => _error(c),
    );
  }
}
