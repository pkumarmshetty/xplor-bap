part of 'translate_bloc.dart';

sealed class TranslateState {
  const TranslateState();
}

final class TranslateInitial extends TranslateState {}

class TranslationLoading extends TranslateState {}

class TranslationFailure extends TranslateState {
  final String? message;

  TranslationFailure({this.message});
}

class TranslationLoaded extends TranslateState {
  final Map<String, dynamic> textMap;

  final bool isNavigation;

  TranslationLoaded({required this.textMap, this.isNavigation = false});
}

class LangListLoaded extends TranslateState {
  final List<LanguageTranslationModel> langList;

  final LanguageTranslationModel recommendedLangModel;
  final LanguageTranslationModel? selectedLanguage;
  final String? message;

  LangListLoaded({required this.langList, this.selectedLanguage, required this.recommendedLangModel, this.message});

  // Copy method
  LangListLoaded copyWith({
    List<LanguageTranslationModel>? langList,
    LanguageTranslationModel? recommendedLangModel,
    AppPageStatus? pageStatus,
    LanguageTranslationModel? selectedLanguage,
  }) {
    return LangListLoaded(
      langList: langList ?? this.langList,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      recommendedLangModel: recommendedLangModel ?? this.recommendedLangModel,
    );
  }
}
