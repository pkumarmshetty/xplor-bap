// To parse this JSON data, do
//
//     final textToTextModel = textToTextModelFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/langugae_entity.dart';

LanguageTranslationModel textToTextModelFromJson(String str) => LanguageTranslationModel.fromJson(json.decode(str));

String textToTextModelToJson(LanguageTranslationModel data) => json.encode(data.toJson());

class LanguageTranslationModel extends LanguageTranslationEntity {
  LanguageTranslationModel({
    required super.symbol,
    required super.language,
    required super.nativeLanguage,
    required super.languageCode,
    required super.percentage,
  });

  factory LanguageTranslationModel.fromJson(Map<String, dynamic> json) => LanguageTranslationModel(
      language: json["language"],
      languageCode: json["languageCode"],
      symbol: json["symbol"],
      nativeLanguage: json["native_language"],
      percentage: json["percentage"]);

  @override
  Map<String, dynamic> toJson() => {
        "language": language,
        "languageCode": languageCode,
        "percentage": percentage,
        "symbol": symbol,
        "native_language": nativeLanguage
      };
}
