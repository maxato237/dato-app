import 'package:isar/isar.dart';

part 'pending_sync_op.g.dart';

/// Outbox durable : une opération de synchronisation en attente de push vers le
/// serveur. Persiste dans Isar pour survivre à un redémarrage de l'app (les
/// écritures faites hors-ligne sont rejouées au retour réseau).
///
/// Coalescence par `quoteId` (index unique) : un seul op par devis, le dernier
/// gagne. Le contenu de l'upsert n'est PAS stocké ici — il est relu depuis
/// `QuoteModel` au moment du push (toujours l'état local le plus récent).
@collection
class PendingSyncOp {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String quoteId;

  /// 'upsert' | 'delete'.
  late String type;

  /// Ordre FIFO (microsecondsSinceEpoch à l'enfilement).
  late int seq;
}
