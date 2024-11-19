import '../../data/models/lang_translation_model.dart';

abstract class LanguageTranslationRepository {
  Future<List<LanguageTranslationModel>> getLanguageList(String body);

  Future<bool> selectedLanguage(String body);

  Future<Map<String, dynamic>> convertTextToText(String body);
}
