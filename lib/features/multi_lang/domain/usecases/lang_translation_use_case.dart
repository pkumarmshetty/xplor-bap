import '../../../../core/use_case.dart';
import '../../data/models/lang_translation_model.dart';
import '../repositories/language_translation_repository.dart';

class LangTranslationUseCase extends UseCase<Map<String, dynamic>, String> {
  final LanguageTranslationRepository repository;

  LangTranslationUseCase({required this.repository});

  @override
  Future<Map<String, dynamic>> call({String? params}) async {
    return await repository.convertTextToText(params!);
  }

  Future<List<LanguageTranslationModel>> getLanguageListData({String? params}) async {
    return await repository.getLanguageList(params!);
  }

  Future<bool> selectedLanguage({String? params}) async {
    return await repository.selectedLanguage(params!);
  }
}
