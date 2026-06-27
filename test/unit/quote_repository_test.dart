import 'package:flutter_test/flutter_test.dart';
import 'package:dato/data/repositories/in_memory_quote_repository.dart';
import 'package:dato/features/quotes/domain/quote.dart';

import '../fixtures/sample_quote.dart';

void main() {
  late InMemoryQuoteRepository repo;

  setUp(() => repo = InMemoryQuoteRepository());
  tearDown(() => repo.dispose());

  group('QuoteRepository (in-memory)', () {
    test('save puis getById : round-trip identique', () async {
      final q = sampleQuote();
      await repo.save(q);

      final read = repo.getById('fix');
      expect(read, isNotNull);
      expect(read!.id, q.id);
      expect(read.client, 'Client Démo');
      expect(read.grandTotal, q.grandTotal);
      expect(read.sections.first.lines.length, 3);
    });

    test('save est un upsert (met à jour le devis existant)', () async {
      await repo.save(sampleQuote());
      await repo.save(sampleQuote().copyWith(client: 'Nouveau Client'));

      expect(repo.getAll().length, 1);
      expect(repo.getById('fix')!.client, 'Nouveau Client');
    });

    test('delete retire le devis', () async {
      await repo.save(sampleQuote());
      await repo.delete('fix');
      expect(repo.getById('fix'), isNull);
      expect(repo.getAll(), isEmpty);
    });

    test('watchAll émet l\'état initial puis à chaque écriture', () async {
      final emissions = <List<Quote>>[];
      final sub = repo.watchAll().listen(emissions.add);

      await repo.save(sampleQuote());
      await repo.save(sampleQuote().copyWith(object: 'Maj'));
      await Future<void>.delayed(Duration.zero);

      // 1 (initial vide) + 2 écritures
      expect(emissions.length, greaterThanOrEqualTo(3));
      expect(emissions.first, isEmpty);
      expect(emissions.last.single.object, 'Maj');

      await sub.cancel();
    });
  });
}
