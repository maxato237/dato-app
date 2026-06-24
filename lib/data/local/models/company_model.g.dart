// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompanyModelCollection on Isar {
  IsarCollection<CompanyModel> get companyModels => this.collection();
}

const CompanyModelSchema = CollectionSchema(
  name: r'CompanyModel',
  id: -1827242308681231162,
  properties: {
    r'activity': PropertySchema(
      id: 0,
      name: r'activity',
      type: IsarType.string,
    ),
    r'address': PropertySchema(
      id: 1,
      name: r'address',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 2,
      name: r'city',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 3,
      name: r'companyId',
      type: IsarType.string,
    ),
    r'currency': PropertySchema(
      id: 4,
      name: r'currency',
      type: IsarType.string,
    ),
    r'dirty': PropertySchema(
      id: 5,
      name: r'dirty',
      type: IsarType.bool,
    ),
    r'location': PropertySchema(
      id: 6,
      name: r'location',
      type: IsarType.string,
    ),
    r'logoUrl': PropertySchema(
      id: 7,
      name: r'logoUrl',
      type: IsarType.string,
    ),
    r'logoUrlToDelete': PropertySchema(
      id: 8,
      name: r'logoUrlToDelete',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 9,
      name: r'name',
      type: IsarType.string,
    ),
    r'pendingLogoPath': PropertySchema(
      id: 10,
      name: r'pendingLogoPath',
      type: IsarType.string,
    ),
    r'phones': PropertySchema(
      id: 11,
      name: r'phones',
      type: IsarType.string,
    ),
    r'quoteNumberByObject': PropertySchema(
      id: 12,
      name: r'quoteNumberByObject',
      type: IsarType.bool,
    ),
    r'quotePrefix': PropertySchema(
      id: 13,
      name: r'quotePrefix',
      type: IsarType.string,
    ),
    r'signatureLeft': PropertySchema(
      id: 14,
      name: r'signatureLeft',
      type: IsarType.string,
    ),
    r'signatureRight': PropertySchema(
      id: 15,
      name: r'signatureRight',
      type: IsarType.string,
    ),
    r'templateDocxUrl': PropertySchema(
      id: 16,
      name: r'templateDocxUrl',
      type: IsarType.string,
    )
  },
  estimateSize: _companyModelEstimateSize,
  serialize: _companyModelSerialize,
  deserialize: _companyModelDeserialize,
  deserializeProp: _companyModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'companyId': IndexSchema(
      id: 482756417767355356,
      name: r'companyId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'companyId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _companyModelGetId,
  getLinks: _companyModelGetLinks,
  attach: _companyModelAttach,
  version: '3.1.0+1',
);

int _companyModelEstimateSize(
  CompanyModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activity.length * 3;
  bytesCount += 3 + object.address.length * 3;
  bytesCount += 3 + object.city.length * 3;
  bytesCount += 3 + object.companyId.length * 3;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.logoUrl.length * 3;
  bytesCount += 3 + object.logoUrlToDelete.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.pendingLogoPath.length * 3;
  bytesCount += 3 + object.phones.length * 3;
  bytesCount += 3 + object.quotePrefix.length * 3;
  bytesCount += 3 + object.signatureLeft.length * 3;
  bytesCount += 3 + object.signatureRight.length * 3;
  bytesCount += 3 + object.templateDocxUrl.length * 3;
  return bytesCount;
}

void _companyModelSerialize(
  CompanyModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.activity);
  writer.writeString(offsets[1], object.address);
  writer.writeString(offsets[2], object.city);
  writer.writeString(offsets[3], object.companyId);
  writer.writeString(offsets[4], object.currency);
  writer.writeBool(offsets[5], object.dirty);
  writer.writeString(offsets[6], object.location);
  writer.writeString(offsets[7], object.logoUrl);
  writer.writeString(offsets[8], object.logoUrlToDelete);
  writer.writeString(offsets[9], object.name);
  writer.writeString(offsets[10], object.pendingLogoPath);
  writer.writeString(offsets[11], object.phones);
  writer.writeBool(offsets[12], object.quoteNumberByObject);
  writer.writeString(offsets[13], object.quotePrefix);
  writer.writeString(offsets[14], object.signatureLeft);
  writer.writeString(offsets[15], object.signatureRight);
  writer.writeString(offsets[16], object.templateDocxUrl);
}

CompanyModel _companyModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CompanyModel();
  object.activity = reader.readString(offsets[0]);
  object.address = reader.readString(offsets[1]);
  object.city = reader.readString(offsets[2]);
  object.companyId = reader.readString(offsets[3]);
  object.currency = reader.readString(offsets[4]);
  object.dirty = reader.readBool(offsets[5]);
  object.isarId = id;
  object.location = reader.readString(offsets[6]);
  object.logoUrl = reader.readString(offsets[7]);
  object.logoUrlToDelete = reader.readString(offsets[8]);
  object.name = reader.readString(offsets[9]);
  object.pendingLogoPath = reader.readString(offsets[10]);
  object.phones = reader.readString(offsets[11]);
  object.quoteNumberByObject = reader.readBool(offsets[12]);
  object.quotePrefix = reader.readString(offsets[13]);
  object.signatureLeft = reader.readString(offsets[14]);
  object.signatureRight = reader.readString(offsets[15]);
  object.templateDocxUrl = reader.readString(offsets[16]);
  return object;
}

P _companyModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _companyModelGetId(CompanyModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _companyModelGetLinks(CompanyModel object) {
  return [];
}

void _companyModelAttach(
    IsarCollection<dynamic> col, Id id, CompanyModel object) {
  object.isarId = id;
}

extension CompanyModelByIndex on IsarCollection<CompanyModel> {
  Future<CompanyModel?> getByCompanyId(String companyId) {
    return getByIndex(r'companyId', [companyId]);
  }

  CompanyModel? getByCompanyIdSync(String companyId) {
    return getByIndexSync(r'companyId', [companyId]);
  }

  Future<bool> deleteByCompanyId(String companyId) {
    return deleteByIndex(r'companyId', [companyId]);
  }

  bool deleteByCompanyIdSync(String companyId) {
    return deleteByIndexSync(r'companyId', [companyId]);
  }

  Future<List<CompanyModel?>> getAllByCompanyId(List<String> companyIdValues) {
    final values = companyIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'companyId', values);
  }

  List<CompanyModel?> getAllByCompanyIdSync(List<String> companyIdValues) {
    final values = companyIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'companyId', values);
  }

  Future<int> deleteAllByCompanyId(List<String> companyIdValues) {
    final values = companyIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'companyId', values);
  }

  int deleteAllByCompanyIdSync(List<String> companyIdValues) {
    final values = companyIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'companyId', values);
  }

  Future<Id> putByCompanyId(CompanyModel object) {
    return putByIndex(r'companyId', object);
  }

  Id putByCompanyIdSync(CompanyModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'companyId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCompanyId(List<CompanyModel> objects) {
    return putAllByIndex(r'companyId', objects);
  }

  List<Id> putAllByCompanyIdSync(List<CompanyModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'companyId', objects, saveLinks: saveLinks);
  }
}

extension CompanyModelQueryWhereSort
    on QueryBuilder<CompanyModel, CompanyModel, QWhere> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CompanyModelQueryWhere
    on QueryBuilder<CompanyModel, CompanyModel, QWhereClause> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> isarIdNotEqualTo(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> companyIdEqualTo(
      String companyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'companyId',
        value: [companyId],
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause>
      companyIdNotEqualTo(String companyId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'companyId',
              lower: [],
              upper: [companyId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'companyId',
              lower: [companyId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'companyId',
              lower: [companyId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'companyId',
              lower: [],
              upper: [companyId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CompanyModelQueryFilter
    on QueryBuilder<CompanyModel, CompanyModel, QFilterCondition> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'activity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'activity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'activity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'activity',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      activityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'activity',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> cityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      cityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> cityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> cityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> cityContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> cityMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdEqualTo(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdLessThan(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdBetween(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdEndsWith(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'companyId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'companyId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'companyId',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      companyIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'companyId',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> dirtyEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dirty',
        value: value,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrlToDelete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'logoUrlToDelete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'logoUrlToDelete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'logoUrlToDelete',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'logoUrlToDelete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'logoUrlToDelete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'logoUrlToDelete',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'logoUrlToDelete',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'logoUrlToDelete',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      logoUrlToDeleteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'logoUrlToDelete',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameContains(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingLogoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pendingLogoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pendingLogoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pendingLogoPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pendingLogoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pendingLogoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pendingLogoPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pendingLogoPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingLogoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      pendingLogoPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pendingLogoPath',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> phonesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> phonesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phones',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phones',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> phonesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phones',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phones',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      phonesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phones',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quoteNumberByObjectEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quoteNumberByObject',
        value: value,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quotePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quotePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quotePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quotePrefix',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'quotePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'quotePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'quotePrefix',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'quotePrefix',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quotePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      quotePrefixIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'quotePrefix',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureLeft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signatureLeft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signatureLeft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signatureLeft',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signatureLeft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signatureLeft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signatureLeft',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signatureLeft',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureLeft',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureLeftIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signatureLeft',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureRight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signatureRight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signatureRight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signatureRight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'signatureRight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'signatureRight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'signatureRight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'signatureRight',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signatureRight',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      signatureRightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'signatureRight',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateDocxUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'templateDocxUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'templateDocxUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'templateDocxUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'templateDocxUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'templateDocxUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'templateDocxUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'templateDocxUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'templateDocxUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
      templateDocxUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'templateDocxUrl',
        value: '',
      ));
    });
  }
}

extension CompanyModelQueryObject
    on QueryBuilder<CompanyModel, CompanyModel, QFilterCondition> {}

extension CompanyModelQueryLinks
    on QueryBuilder<CompanyModel, CompanyModel, QFilterCondition> {}

extension CompanyModelQuerySortBy
    on QueryBuilder<CompanyModel, CompanyModel, QSortBy> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByLogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByLogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByLogoUrlToDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrlToDelete', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByLogoUrlToDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrlToDelete', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByPendingLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLogoPath', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByPendingLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLogoPath', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByPhones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phones', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByPhonesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phones', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByQuoteNumberByObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteNumberByObject', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByQuoteNumberByObjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteNumberByObject', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByQuotePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quotePrefix', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByQuotePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quotePrefix', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortBySignatureLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLeft', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortBySignatureLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLeft', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortBySignatureRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureRight', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortBySignatureRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureRight', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByTemplateDocxUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateDocxUrl', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      sortByTemplateDocxUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateDocxUrl', Sort.desc);
    });
  }
}

extension CompanyModelQuerySortThenBy
    on QueryBuilder<CompanyModel, CompanyModel, QSortThenBy> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByActivity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByActivityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activity', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByDirtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dirty', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByLogoUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByLogoUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrl', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByLogoUrlToDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrlToDelete', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByLogoUrlToDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'logoUrlToDelete', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByPendingLogoPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLogoPath', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByPendingLogoPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingLogoPath', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByPhones() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phones', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByPhonesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phones', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByQuoteNumberByObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteNumberByObject', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByQuoteNumberByObjectDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quoteNumberByObject', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByQuotePrefix() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quotePrefix', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByQuotePrefixDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quotePrefix', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenBySignatureLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLeft', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenBySignatureLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureLeft', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenBySignatureRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureRight', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenBySignatureRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'signatureRight', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByTemplateDocxUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateDocxUrl', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
      thenByTemplateDocxUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'templateDocxUrl', Sort.desc);
    });
  }
}

extension CompanyModelQueryWhereDistinct
    on QueryBuilder<CompanyModel, CompanyModel, QDistinct> {
  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByActivity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByCity(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByCompanyId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByDirty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dirty');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByLocation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByLogoUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByLogoUrlToDelete(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'logoUrlToDelete',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByPendingLogoPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingLogoPath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByPhones(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phones', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct>
      distinctByQuoteNumberByObject() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quoteNumberByObject');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByQuotePrefix(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quotePrefix', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctBySignatureLeft(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signatureLeft',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctBySignatureRight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signatureRight',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByTemplateDocxUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'templateDocxUrl',
          caseSensitive: caseSensitive);
    });
  }
}

extension CompanyModelQueryProperty
    on QueryBuilder<CompanyModel, CompanyModel, QQueryProperty> {
  QueryBuilder<CompanyModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> activityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activity');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<CompanyModel, bool, QQueryOperations> dirtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dirty');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> logoUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoUrl');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations>
      logoUrlToDeleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'logoUrlToDelete');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations>
      pendingLogoPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingLogoPath');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> phonesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phones');
    });
  }

  QueryBuilder<CompanyModel, bool, QQueryOperations>
      quoteNumberByObjectProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quoteNumberByObject');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> quotePrefixProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quotePrefix');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> signatureLeftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signatureLeft');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations>
      signatureRightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signatureRight');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations>
      templateDocxUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'templateDocxUrl');
    });
  }
}
