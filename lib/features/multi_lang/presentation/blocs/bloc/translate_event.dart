part of 'translate_bloc.dart';

sealed class TranslateEvent extends Equatable {
  const TranslateEvent();

  @override
  List<Object> get props => [];
}

class TranslateDynamicTextEvent extends TranslateEvent {
  final String langCode;
  final String moduleTypes;
  final bool isNavigation;

  const TranslateDynamicTextEvent({required this.langCode, required this.moduleTypes, this.isNavigation = false});
}

class GetLanguageListEvent extends TranslateEvent {
  const GetLanguageListEvent();
}

class SelectLanguageEvent extends TranslateEvent {
  final LanguageTranslationModel selected;

  const SelectLanguageEvent({required this.selected});
}

class ChooseLangCodeEvent extends TranslateEvent {
  final bool hasRegisterId;

  const ChooseLangCodeEvent({this.hasRegisterId = false});
}
