import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:xplor/features/profile/domain/usecase/profile_usecase.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../on_boarding/domain/entities/user_data_entity.dart';

part 'seeker_profile_event.dart';

part 'seeker_profile_state.dart';

class SeekerProfileBloc extends Bloc<SeekerProfileEvent, SeekerProfileState> {
  ProfileUseCase profileUseCase;
  UserDataEntity? userData;
  bool isTranslationDone = false;

  SeekerProfileBloc({required this.profileUseCase}) : super(ProfileInitialState()) {
    on<ProfileUserDataEvent>(_onProfileInitial);
    on<SeekerProfileLogoutEvent>(_onLogout);
    on<ProfileAndTranslationEvent>(_onProfileTranslationDone);
  }

  Future<void> _onProfileInitial(ProfileUserDataEvent event, Emitter<SeekerProfileState> emit) async {
    isTranslationDone = false;
    try {
      emit(state.copyWith(
          profileState: ProfileState.loading, userData: null, uniqueId: DateTime.now().millisecondsSinceEpoch));
      userData = await profileUseCase.getUserData();
      if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode) == "en") {
        emit(state.copyWith(
            profileState: ProfileState.done, userData: userData, uniqueId: DateTime.now().millisecondsSinceEpoch));
      } else {
        emit(state.copyWith(
            profileState: ProfileState.userDataLoaded,
            userData: userData,
            uniqueId: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      emit(state.copyWith(
          profileState: ProfileState.failure,
          userData: null,
          message: AppUtils.getErrorMessage(e.toString()),
          uniqueId: DateTime.now().millisecondsSinceEpoch));
      // emit(ProfileUserDataFailureState(errorMessage: AppUtils.getErrorMessage(e.toString())));
      //throw Exception(e.toString());
    }
  }

  Future<void> _onLogout(SeekerProfileLogoutEvent event, Emitter<SeekerProfileState> emit) async {
    try {
      await profileUseCase.logout();
      emit(ProfileLogoutState());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  FutureOr<void> _onProfileTranslationDone(ProfileAndTranslationEvent event, Emitter<SeekerProfileState> emit) {
    debugPrint("data..... ${event.isTranslationDone}");
    debugPrint("data..... $userData");
    if (!isTranslationDone && event.isTranslationDone != null) {
      isTranslationDone = true;
    }
    if (isTranslationDone && userData != null) {
      emit(state.copyWith(
          profileState: ProfileState.done, userData: userData, uniqueId: DateTime.now().millisecondsSinceEpoch));
    }
  }
}
