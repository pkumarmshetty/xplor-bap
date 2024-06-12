// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/features/multi_lang/domain/mappers/home/home_map.dart';
import 'package:xplor/features/multi_lang/domain/mappers/on_boarding/on_boarding_map.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_map.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_map.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import '../../../../../const/app_state.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/mapping_const.dart';
import '../../../data/models/lang_translation_model.dart';
import '../../../domain/mappers/network_errors/network_errors_map.dart';
import '../../../domain/mappers/seeker_home/seeker_home_map.dart';
import '../../../domain/usecases/lang_translation_use_case.dart';

part 'translate_event.dart';

part 'translate_state.dart';

class TranslationBloc extends Bloc<TranslateEvent, TranslateState> {
  Map<String, dynamic> dummyMapKey = {};
  int requestsSent = 0;
  List<LanguageTranslationModel> langModel = [];
  LanguageTranslationModel? selectedModel;
  LanguageTranslationModel? recommendedLangModel;
  LangTranslationUseCase useCase;

  //=======================Texts That are Static=========================

  Map<String, dynamic> translationTextMap = {};

  TranslationBloc({required this.useCase}) : super(TranslateInitial()) {
    on<TranslateDynamicTextEvent>(_getLangMapping);
    on<GetLanguageListEvent>(_getLanguageList);
    on<SelectLanguageEvent>(_updateSelectionIndex);
    on<ChooseLangCodeEvent>(_chooseLangApi);
  }

  _getLanguageList(GetLanguageListEvent event, Emitter<TranslateState> emit) async {
    /// emit loading state

    try {
      emit(TranslationLoading());

      langModel = await useCase.getLanguageListData(params: "");

      LanguageTranslationModel? highestPercentageObject;
      double highestPercentage = 0;

      for (var model in langModel) {
        double percentage = double.tryParse(model.percentage.replaceAll('%', '')) ?? 0;

        if (percentage > highestPercentage) {
          highestPercentage = percentage;
          highestPercentageObject = model;
        }
      }
      langModel.remove(highestPercentageObject);
      selectedModel = highestPercentageObject;
      recommendedLangModel = highestPercentageObject;
      sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedLanguageCode, selectedModel!.languageCode);

      emit(LangListLoaded(
          langList: langModel,
          recommendedLangModel: highestPercentageObject!,
          selectedLanguage: highestPercentageObject));
    } catch (e) {
      var model = LanguageTranslationModel(
          language: "English", languageCode: "en", percentage: "4.7%", symbol: "A", nativeLanguage: "English");

      selectedModel = model;
      recommendedLangModel = model;
      sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedLanguageCode, model.languageCode);

      sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedLanguageCode, selectedModel!.languageCode);

      emit(LangListLoaded(
          langList: [model],
          recommendedLangModel: model,
          selectedLanguage: model,
          message: 'Other Languages are not available due to the server error'));

      /// emit error state for any error encountered
      //emit(TranslationFailure(message: 'Other Languages are not available due to the server error'));
    }
  }

  _updateSelectionIndex(SelectLanguageEvent event, Emitter<TranslateState> emit) {
    selectedModel = event.selected;
    emit((state as LangListLoaded).copyWith(selectedLanguage: event.selected));
  }

  _chooseLangApi(ChooseLangCodeEvent event, Emitter<TranslateState> emit) async {
    try {
      emit(TranslationLoading());

      if (kDebugMode) {
        print(event.hasRegisterId);
      }
      if (event.hasRegisterId) {
        Map<String, dynamic> dataMap = <String, dynamic>{};
        dataMap['deviceId'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);
        dataMap['languageCode'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode);
        sl<OnBoardingUseCase>().updateDevicePreference(dataMap);
      } else {
        await useCase.selectedLanguage(params: "");
      }

      add(TranslateDynamicTextEvent(
          langCode: selectedModel!.languageCode, moduleTypes: onBoardingModule, isNavigation: true));
    } catch (e) {
      /// emit error state for any error encountered
      emit(TranslationFailure(message: AppUtils.getErrorMessage(e.toString())));
    }
  }

  _getLangMapping(TranslateDynamicTextEvent event, Emitter<TranslateState> emit) async {
    emit(TranslationLoading());

    try {
      if (event.langCode.trim().toLowerCase() == "en") {
        translationTextMap = getMapping(event.moduleTypes);
        emit(TranslationLoaded(textMap: translationTextMap, isNavigation: event.isNavigation));
      } else {
        var onBoardingTranslatedData = sl<SharedPreferencesHelper>().getString(onBoardingModule);
        if (event.moduleTypes == onBoardingModule &&
            (onBoardingTranslatedData != "NA" && onBoardingTranslatedData != "")) {
          Map<String, dynamic> data = jsonDecode(onBoardingTranslatedData);
          translationTextMap.addAll(data);
        } else {
          debugPrint("translationTextMap before Translation: ${translationTextMap.length}");
          var body = json.encode({
            "targetLanguage": sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
            "sourceLanguage": "en",
            "content": getMapping(event.moduleTypes)
          });

          final value = await useCase.call(params: body);
          debugPrint("translationTextMap after Translation: ${translationTextMap.length}");
          translationTextMap.addAll(value);

          if (event.moduleTypes == onBoardingModule) {
            String jsonString = jsonEncode(value);
            sl<SharedPreferencesHelper>().setString(onBoardingModule, jsonString);
          }
        }

        debugPrint("translationTextMap after adding Translation: ${translationTextMap.length}");
        emit(TranslationLoaded(textMap: translationTextMap, isNavigation: event.isNavigation));
        emit(TranslateInitial());
      }
    } catch (e) {
      /// emit error state for any error encountered
      emit(TranslationFailure(message: AppUtils.getErrorMessage(e.toString())));
    }
  }

  Map<String, dynamic> getMapping(String type) {
    Map<String, dynamic> mapping = {};
    switch (type) {
      case onBoardingModule:
        mapping.clear();
        mapping.addAll(originalOnBoardingMap);
        return mapping;

      case homeModule:
        mapping.clear();
        mapping.addAll(originalHomeMap);
        return mapping;

      case walletModule:
        mapping.clear();
        mapping.addAll(originalWalletMap);
        return mapping;

      case profileModule:
        mapping.clear();
        mapping.addAll(originalProfileMap);
        return mapping;

      /* case mPinModule:
        mPinMap.clear();
        mPinMap.addAll(originalMPinMap);
        return mPinMap;*/

      case seekerHomeModule:
        mapping.clear();
        mapping.addAll(originalSeekerHomeMap);
        return mapping;

      case networkErrorsModule:
        mapping.clear();
        mapping.addAll(originalNetworkErrorMaps);
        return mapping;

      default:
        mapping.clear();
        mapping.addAll(originalOnBoardingMap);
        return mapping;
    }
  }
}
