// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArticleModelCollection on Isar {
  IsarCollection<ArticleModel> get articleModels => this.collection();
}

const ArticleModelSchema = CollectionSchema(
  name: r'ArticleModel',
  id: -8044723749600999942,
  properties: {
    r'articleId': PropertySchema(
      id: 0,
      name: r'articleId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'pu': PropertySchema(
      id: 2,
      name: r'pu',
      type: IsarType.long,
    )
  },
  estimateSize: _articleModelEstimateSize,
  serialize: _articleModelSerialize,
  deserialize: _articleModelDeserialize,
  deserializeProp: _articleModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'articleId': IndexSchema(
      id: 2849477555030470394,
      name: r'articleId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'articleId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _articleModelGetId,
  getLinks: _articleModelGetLinks,
  attach: _articleModelAttach,
  version: '3.1.0+1',
);

int _articleModelEstimateSize(
  ArticleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.articleId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _articleModelSerialize(
  ArticleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.articleId);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.pu);
}

ArticleModel _articleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ArticleModel();
  object.articleId = reader.readString(offsets[0]);
  object.isarId = id;
  object.name = reader.readString(offsets[1]);
  object.pu = reader.readLong(offsets[2]);
  return object;
}

P _articleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _articleModelGetId(ArticleModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _articleModelGetLinks(ArticleModel object) {
  return [];
}

void _articleModelAttach(
    IsarCollection<dynamic> col, Id id, ArticleModel object) {
  object.isarId = id;
}

extension ArticleModelByIndex on IsarCollection<ArticleModel> {
  Future<ArticleModel?> getByArticleId(String articleId) {
    return getByIndex(r'articleId', [articleId]);
  }

  ArticleModel? getByArticleIdSync(String articleId) {
    return getByIndexSync(r'articleId', [articleId]);
  }

  Future<bool> deleteByArticleId(String articleId) {
    return deleteByIndex(r'articleId', [articleId]);
  }

  bool deleteByArticleIdSync(String articleId) {
    return deleteByIndexSync(r'articleId', [articleId]);
  }

  Future<List<ArticleModel?>> getAllByArticleId(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'articleId', values);
  }

  List<ArticleModel?> getAllByArticleIdSync(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'articleId', values);
  }

  Future<int> deleteAllByArticleId(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'articleId', values);
  }

  int deleteAllByArticleIdSync(List<String> articleIdValues) {
    final values = articleIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'articleId', values);
  }

  Future<Id> putByArticleId(ArticleModel object) {
    return putByIndex(r'articleId', object);
  }

  Id putByArticleIdSync(ArticleModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'articleId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByArticleId(List<ArticleModel> objects) {
    return putAllByIndex(r'articleId', objects);
  }

  List<Id> putAllByArticleIdSync(List<ArticleModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'articleId', objects, saveLinks: saveLinks);
  }
}

extension ArticleModelQueryWhereSort
    on QueryBuilder<ArticleModel, ArticleModel, QWhere> {
  QueryBuilder<ArticleModel, ArticleModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ArticleModelQueryWhere
    on QueryBuilder<ArticleModel, ArticleModel, QWhereClause> {
  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause> articleIdEqualTo(
      String articleId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'articleId',
        value: [articleId],
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterWhereClause>
      articleIdNotEqualTo(String articleId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [],
              upper: [articleId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [articleId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [articleId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'articleId',
              lower: [],
              upper: [articleId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ArticleModelQueryFilter
    on QueryBuilder<ArticleModel, ArticleModel, QFilterCondition> {
  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'articleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'articleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'articleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'articleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      articleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'articleId',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> puEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pu',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> puGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pu',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> puLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pu',
        value: value,
      ));
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterFilterCondition> puBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ArticleModelQueryObject
    on QueryBuilder<ArticleModel, ArticleModel, QFilterCondition> {}

extension ArticleModelQueryLinks
    on QueryBuilder<ArticleModel, ArticleModel, QFilterCondition> {}

extension ArticleModelQuerySortBy
    on QueryBuilder<ArticleModel, ArticleModel, QSortBy> {
  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> sortByArticleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> sortByArticleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.desc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> sortByPu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pu', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> sortByPuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pu', Sort.desc);
    });
  }
}

extension ArticleModelQuerySortThenBy
    on QueryBuilder<ArticleModel, ArticleModel, QSortThenBy> {
  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByArticleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByArticleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'articleId', Sort.desc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByPu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pu', Sort.asc);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QAfterSortBy> thenByPuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pu', Sort.desc);
    });
  }
}

extension ArticleModelQueryWhereDistinct
    on QueryBuilder<ArticleModel, ArticleModel, QDistinct> {
  QueryBuilder<ArticleModel, ArticleModel, QDistinct> distinctByArticleId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'articleId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArticleModel, ArticleModel, QDistinct> distinctByPu() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pu');
    });
  }
}

extension ArticleModelQueryProperty
    on QueryBuilder<ArticleModel, ArticleModel, QQueryProperty> {
  QueryBuilder<ArticleModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ArticleModel, String, QQueryOperations> articleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'articleId');
    });
  }

  QueryBuilder<ArticleModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ArticleModel, int, QQueryOperations> puProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pu');
    });
  }
}
