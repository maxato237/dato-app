import 'dart:convert';

import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/quotes/data/quote_dto.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

import 'models/article_model.dart';
import 'models/company_model.dart';
import 'models/quote_model.dart';

/// Conversions domaine ↔ modèles Isar. Le devis riche transite par le snapshot
/// JSON (`document_json`), réutilisant la sérialisation de `quote_dto.dart`.

QuoteModel quoteToModel(Quote q) => QuoteModel()
  ..quoteId = q.id
  ..number = q.number
  ..object = q.object
  ..client = q.client
  ..status = quoteStatusToServer(q.status)
  ..date = q.date
  ..grandTotal = q.grandTotal
  ..companyId = q.companyId
  ..documentJson = jsonEncode(q.toDocumentJson());

Quote quoteToDomain(QuoteModel m) => quoteFromDocumentJson(
      (jsonDecode(m.documentJson) as Map).cast<String, dynamic>(),
      companyId: m.companyId,
    );

CompanyModel companyToModel(Company c) => CompanyModel()
  ..companyId = c.id
  ..name = c.name
  ..activity = c.activity
  ..address = c.address
  ..phones = c.phones
  ..city = c.city
  ..currency = c.currency
  ..logoUrl = c.logoUrl
  ..location = c.location
  ..templateDocxUrl = c.templateDocxUrl
  ..signatureLeft = c.signatureLeft
  ..signatureRight = c.signatureRight
  ..quotePrefix = c.quotePrefix
  ..quoteNumberByObject = c.quoteNumberByObject;

Company companyToDomain(CompanyModel m) => Company(
      id: m.companyId,
      name: m.name,
      activity: m.activity,
      address: m.address,
      phones: m.phones,
      city: m.city,
      currency: m.currency,
      logoUrl: m.logoUrl,
      location: m.location,
      templateDocxUrl: m.templateDocxUrl,
      signatureLeft: m.signatureLeft,
      signatureRight: m.signatureRight,
      quotePrefix: m.quotePrefix,
      quoteNumberByObject: m.quoteNumberByObject,
    );

ArticleModel articleToModel(Article a) => ArticleModel()
  ..articleId = a.id
  ..name = a.name
  ..pu = a.pu;

Article articleToDomain(ArticleModel m) =>
    Article(id: m.articleId, name: m.name, pu: m.pu);
