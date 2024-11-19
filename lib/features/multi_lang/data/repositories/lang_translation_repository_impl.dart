import 'package:xplor/features/multi_lang/data/models/lang_translation_model.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/repositories/language_translation_repository.dart';
import '../datasources/language_translate_remote.dart';

class LanguageTranslationRepositoryImpl implements LanguageTranslationRepository {
  LanguageTranslationRemote languageTranslationRemote;
  NetworkInfo networkInfo;

  LanguageTranslationRepositoryImpl({required this.languageTranslationRemote, required this.networkInfo});

  @override
  Future<Map<String, dynamic>> convertTextToText(String text) async {
    if (await networkInfo.isConnected!) {
      return languageTranslationRemote.translateMap(text);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection);
    }
  }

  @override
  Future<List<LanguageTranslationModel>> getLanguageList(String body) async {
    if (await networkInfo.isConnected!) {
      return languageTranslationRemote.getLanguageModel(body);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection);
    }
  }

  @override
  Future<bool> selectedLanguage(String body) async {
    if (await networkInfo.isConnected!) {
      return languageTranslationRemote.selectedLanguageApi(body);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection);
    }
  }
}
