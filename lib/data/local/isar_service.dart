import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/article_model.dart';
import 'models/binary_asset.dart';
import 'models/company_model.dart';
import 'models/pending_sync_op.dart';
import 'models/quote_model.dart';

/// Instance Isar ouverte. `null` tant que [main] ne l'a pas injectée via
/// override (tests, ou si l'ouverture échoue) → les dépôts retombent sur leur
/// implémentation en mémoire. **Toujours** surchargé dans `main()`.
final isarProvider = Provider<Isar?>((_) => null);

/// Ouvre la base Isar de l'application dans le dossier documents.
Future<Isar> openAppIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      QuoteModelSchema,
      CompanyModelSchema,
      ArticleModelSchema,
      BinaryAssetSchema,
      PendingSyncOpSchema,
    ],
    directory: dir.path,
    name: 'dato',
  );
}
