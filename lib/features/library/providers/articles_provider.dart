import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dato/features/library/domain/article.dart';

/// Bibliothèque d'articles disponible pour l'auto-complétion de désignation.
///
/// Seedée en mémoire pour la Phase 2. La Phase 8 (CRUD bibliothèque) la
/// remplacera par un dépôt persistant exposé sous le même provider.
final articlesProvider = Provider<List<Article>>((ref) => const [
      Article(id: 'a1', name: 'Planches', pu: 6000),
      Article(id: 'a2', name: 'Madriers', pu: 7000),
      Article(id: 'a3', name: 'Litres de colle', pu: 3000),
      Article(id: 'a4', name: 'Litres de fond-dur', pu: 5000),
      Article(id: 'a5', name: 'Litres de diluant', pu: 1500),
      Article(id: 'a6', name: 'Bandes à poncer', pu: 24000),
      Article(id: 'a7', name: 'Teintes', pu: 12000),
      Article(id: 'a8', name: 'Paquets de vis', pu: 8000),
      Article(id: 'a9', name: 'Paquets de pointe', pu: 4500),
      Article(id: 'a10', name: 'Pot de teinture', pu: 12000),
      Article(id: 'a11', name: 'Lattes', pu: 1800),
      Article(id: 'a12', name: 'Lambris (m²)', pu: 6000),
    ]);
