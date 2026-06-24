// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetQuoteModelCollection on Isar {
  IsarCollection<QuoteModel> get quoteModels => this.collection();
}

const QuoteModelSchema = CollectionSchema(
  name: r'QuoteModel',
  id: 7683860720290120396,
  properties: {
    r'client': PropertySchema(
      id: 0,
      name: r'client',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 1,
      name: r'companyId',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.string,
    ),
    r'documentJson': PropertySchema(
      id: 3,
      name: r'documentJson',
      type: IsarType.string,
    ),
    r'grandTotal': PropertySchema(
      id: 4,
      name: r'grandTotal',
      type: IsarType.double,
    ),
    r'number': PropertySchema(
      id: 5,
      name: r'number',
      type: IsarType.string,
    ),
    r'object': PropertySchema(
      id: 6,
      name: r'object',
      type: IsarType.string,
    ),
    r'quoteId': PropertySchema(
      id: 7,
      name: r'quoteId',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 8,
      name: r'status',
      type: IsarType.string,
    )
  },
  estimateSize: _quoteModelEstimateSize,
  serialize: _quoteModelSerialize,
  deserialize: _quoteModelDeserialize,
  deserializeProp: _quoteModelDeserializeProp,
  idName: r'isarId',
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
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _quoteModelGetId,
  getLinks: _quoteModelGetLinks,
  attach: _quoteModelAttach,
  version: '3.1.0+1',
);

int _quoteModelEstimateSize(
  QuoteModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.client.length * 3;
  bytesCount += 3 + object.companyId.length * 3;
  bytesCount += 3 + object.date.length * 3;
  bytesCount += 3 + object.documentJson.length * 3;
  bytesCount += 3 + object.number.length * 3;
  bytesCount += 3 + object.object.length * 3;
  bytesCount += 3 + object.quoteId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _quoteModelSerialize(
  QuoteModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.client);
  writer.writeString(offsets[1], object.companyId);
  writer.writeString(offsets[2], object.date);
  writer.writeString(offsets[3], object.documentJson);
  writer.writeDouble(offsets[4], object.grandTotal);
  writer.writeString(offsets[5], object.number);
  writer.writeString(offsets[6], object.object);
  writer.writeString(offsets[7], object.quoteId);
  writer.writeString(offsets[8], object.status);
}

QuoteModel _quoteModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = QuoteModel();
  object.client = reader.readString(offsets[0]);
  object.companyId = reader.readString(offsets[1]);
  object.date = reader.readString(offsets[2]);
  object.documentJson = reader.readString(offsets[3]);
  object.grandTotal = reader.readDouble(offsets[4]);
  object.isarId = id;
  object.number = reader.readString(offsets[5]);
  object.object = reader.readString(offsets[6]);
  object.quoteId = reader.readString(offsets[7]);
  object.status = reader.readString(offsets[8]);
  return object;
}

P _quoteModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _quoteModelGetId(QuoteModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _quoteModelGetLinks(QuoteModel object) {
  return [];
}

void _quoteModelAttach(IsarCollection<dynamic> col, Id id, QuoteModel object) {
  object.isarId = id;
}

extension QuoteModelByIndex on IsarCollection<QuoteModel> {
  Future<QuoteModel?> getByQuoteId(String quoteId) {
    return getByIndex(r'quoteId', [quoteId]);
  }

  QuoteModel? getByQuoteIdSync(String quoteId) {
    return getByIndexSync(r'quoteId', [quoteId]);
  }

  Future<bool> deleteByQuoteId(String quoteId) {
    return deleteByIndex(r'quoteId', [quoteId]);
  }

  bool deleteByQuoteIdSync(String quoteId) {
    return deleteByIndexSync(r'quoteId', [quoteId]);
  }

  Future<List<QuoteModel?>> getAllByQuoteId(List<String> quoteIdValues) {
    final values = quoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'quoteId', values);
  }

  List<QuoteModel?> getAllByQuoteIdSync(List<String> quoteIdValues) {
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

  Future<Id> putByQuoteId(QuoteModel object) {
    return putByIndex(r'quoteId', object);
  }

  Id putByQuoteIdSync(QuoteModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'quoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByQuoteId(List<QuoteModel> objects) {
    return putAllByIndex(r'quoteId', objects);
  }

  List<Id> putAllByQuoteIdSync(List<QuoteModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'quoteId', objects, saveLinks: saveLinks);
  }
}

extension QuoteModelQueryWhereSort
    on QueryBuilder<QuoteModel, QuoteModel, QWhere> {
  QueryBuilder<QuoteModel, QuoteModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension QuoteModelQueryWhere
    on QueryBuilder<QuoteModel, QuoteModel, QWhereClause> {
  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> quoteIdEqualTo(
      String quoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'quoteId',
        value: [quoteId],
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> quoteIdNotEqualTo(
      String quoteId) {
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> statusEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> statusNotEqualTo(
      String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> dateEqualTo(
      String date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterWhereClause> dateNotEqualTo(
      String date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }
}

extension QuoteModelQueryFilter
    on QueryBuilder<QuoteModel, QuoteModel, QFilterCondition> {
  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'client',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'client',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> clientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'client',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      clientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'client',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> companyIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      companyIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> companyIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> companyIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'companyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      companyIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> companyIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> companyIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> companyIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      companyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      companyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyId',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'documentJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'documentJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'documentJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'documentJson',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      documentJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'documentJson',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> grandTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grandTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      grandTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grandTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      grandTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grandTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> grandTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grandTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'number',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'number',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'number',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'number',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'number',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'number',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'number',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> numberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      numberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'number',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'object',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'object',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'object',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'object',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'object',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'object',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'object',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'object',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> objectIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'object',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      objectIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'object',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdEqualTo(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdLessThan(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdBetween(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdStartsWith(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdEndsWith(
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

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> quoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      quoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }
}

extension QuoteModelQueryObject
    on QueryBuilder<QuoteModel, QuoteModel, QFilterCondition> {}

extension QuoteModelQueryLinks
    on QueryBuilder<QuoteModel, QuoteModel, QFilterCondition> {}

extension QuoteModelQuerySortBy
    on QueryBuilder<QuoteModel, QuoteModel, QSortBy> {
  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByClient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByClientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByDocumentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByDocumentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByGrandTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByGrandTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'object', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByObjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'object', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByQuoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByQuoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension QuoteModelQuerySortThenBy
    on QueryBuilder<QuoteModel, QuoteModel, QSortThenBy> {
  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByClient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByClientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByDocumentJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByDocumentJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'documentJson', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByGrandTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByGrandTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grandTotal', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'object', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByObjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'object', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByQuoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByQuoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteId', Sort.desc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension QuoteModelQueryWhereDistinct
    on QueryBuilder<QuoteModel, QuoteModel, QDistinct> {
  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByClient(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'client', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByCompanyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByDocumentJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'documentJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByGrandTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grandTotal');
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'number', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByObject(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'object', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByQuoteId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<QuoteModel, QuoteModel, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension QuoteModelQueryProperty
    on QueryBuilder<QuoteModel, QuoteModel, QQueryProperty> {
  QueryBuilder<QuoteModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> clientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'client');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> documentJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'documentJson');
    });
  }

  QueryBuilder<QuoteModel, double, QQueryOperations> grandTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grandTotal');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> numberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'number');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> objectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'object');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> quoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteId');
    });
  }

  QueryBuilder<QuoteModel, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
