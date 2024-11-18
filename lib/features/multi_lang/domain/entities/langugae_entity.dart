class LanguageTranslationEntity {
  final String language;
  final String languageCode;
  final String percentage;
  final String nativeLanguage;
  final String symbol;

  LanguageTranslationEntity({
    required this.language,
    required this.languageCode,
    required this.percentage,
    required this.nativeLanguage,
    required this.symbol,
  });

  factory LanguageTranslationEntity.fromJson(Map<String, dynamic> json) => LanguageTranslationEntity(
      language: json["language"],
      languageCode: json["languageCode"],
      symbol: json["symbol"],
      nativeLanguage: json["native_language"],
      percentage: json["percentage"]);

  Map<String, dynamic> toJson() => {
        "language": language,
        "languageCode": languageCode,
        "percentage": percentage,
        "symbol": symbol,
        "native_language": nativeLanguage
      };
}
