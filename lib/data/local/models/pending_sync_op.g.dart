// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_sync_op.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPendingSyncOpCollection on Isar {
  IsarCollection<PendingSyncOp> get pendingSyncOps => this.collection();
}

const PendingSyncOpSchema = CollectionSchema(
  name: r'PendingSyncOp',
  id: 2713313173715855573,
  properties: {
    r'quoteId': PropertySchema(
      id: 0,
      name: r'quoteId',
      type: IsarType.string,
    ),
    r'seq': PropertySchema(
      id: 1,
      name: r'seq',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 2,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _pendingSyncOpEstimateSize,
  serialize: _pendingSyncOpSerialize,
  deserialize: _pendingSyncOpDeserialize,
  deserializeProp: _pendingSyncOpDeserializeProp,
  idName: r'id',
  indexes: {
    r'quoteId': IndexSchema(
      id: -8613099003942434395,
      name: r'quoteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'quoteId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _pendingSyncOpGetId,
  getLinks: _pendingSyncOpGetLinks,
  attach: _pendingSyncOpAttach,
  version: '3.1.0+1',
);

int _pendingSyncOpEstimateSize(
  PendingSyncOp object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.quoteId.length * 3;
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _pendingSyncOpSerialize(
  PendingSyncOp object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.quoteId);
  writer.writeLong(offsets[1], object.seq);
  writer.writeString(offsets[2], object.type);
}

PendingSyncOp _pendingSyncOpDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingSyncOp();
  object.id = id;
  object.quoteId = reader.readString(offsets[0]);
  object.seq = reader.readLong(offsets[1]);
  object.type = reader.readString(offsets[2]);
  return object;
}

P _pendingSyncOpDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingSyncOpGetId(PendingSyncOp object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pendingSyncOpGetLinks(PendingSyncOp object) {
  return [];
}

void _pendingSyncOpAttach(
    IsarCollection<dynamic> col, Id id, PendingSyncOp object) {
  object.id = id;
}

extension PendingSyncOpByIndex on IsarCollection<PendingSyncOp> {
  Future<PendingSyncOp?> getByQuoteId(String quoteId) {
    return getByIndex(r'quoteId', [quoteId]);
  }

  PendingSyncOp? getByQuoteIdSync(String quoteId) {
    return getByIndexSync(r'quoteId', [quoteId]);
  }

  Future<bool> deleteByQuoteId(String quoteId) {
    return deleteByIndex(r'quoteId', [quoteId]);
  }

  bool deleteByQuoteIdSync(String quoteId) {
    return deleteByIndexSync(r'quoteId', [quoteId]);
  }

  Future<List<PendingSyncOp?>> getAllByQuoteId(List<String> quoteIdValues) {
    final values = quoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'quoteId', values);
  }

  List<PendingSyncOp?> getAllByQuoteIdSync(List<String> quoteIdValues) {
    final values = quoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'quoteId', values);
  }

  Future<int> deleteAllByQuoteId(List<String> quoteIdValues) {
    final values = quoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'quoteId', values);
  }

  int deleteAllByQuoteIdSync(List<String> quoteIdValues) {
    final values = quoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'quoteId', values);
  }

  Future<Id> putByQuoteId(PendingSyncOp object) {
    return putByIndex(r'quoteId', object);
  }

  Id putByQuoteIdSync(PendingSyncOp object, {bool saveLinks = true}) {
    return putByIndexSync(r'quoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQuoteId(List<PendingSyncOp> objects) {
    return putAllByIndex(r'quoteId', objects);
  }

  List<Id> putAllByQuoteIdSync(List<PendingSyncOp> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'quoteId', objects, saveLinks: saveLinks);
  }
}

extension PendingSyncOpQueryWhereSort
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QWhere> {
  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingSyncOpQueryWhere
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QWhereClause> {
  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause> quoteIdEqualTo(
      String quoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'quoteId',
        value: [quoteId],
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterWhereClause>
      quoteIdNotEqualTo(String quoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quoteId',
              lower: [],
              upper: [quoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quoteId',
              lower: [quoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quoteId',
              lower: [quoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'quoteId',
              lower: [],
              upper: [quoteId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PendingSyncOpQueryFilter
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QFilterCondition> {
  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      quoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> seqEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seq',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      seqGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seq',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> seqLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seq',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> seqBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seq',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension PendingSyncOpQueryObject
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QFilterCondition> {}

extension PendingSyncOpQueryLinks
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QFilterCondition> {}

extension PendingSyncOpQuerySortBy
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QSortBy> {
  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> sortByQuoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> sortByQuoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> sortBySeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seq', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> sortBySeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seq', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension PendingSyncOpQuerySortThenBy
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QSortThenBy> {
  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenByQuoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenByQuoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenBySeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seq', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenBySeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seq', Sort.desc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension PendingSyncOpQueryWhereDistinct
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QDistinct> {
  QueryBuilder<PendingSyncOp, PendingSyncOp, QDistinct> distinctByQuoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QDistinct> distinctBySeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seq');
    });
  }

  QueryBuilder<PendingSyncOp, PendingSyncOp, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }
}

extension PendingSyncOpQueryProperty
    on QueryBuilder<PendingSyncOp, PendingSyncOp, QQueryProperty> {
  QueryBuilder<PendingSyncOp, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PendingSyncOp, String, QQueryOperations> quoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteId');
    });
  }

  QueryBuilder<PendingSyncOp, int, QQueryOperations> seqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seq');
    });
  }

  QueryBuilder<PendingSyncOp, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
