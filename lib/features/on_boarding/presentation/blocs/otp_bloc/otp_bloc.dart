import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:xplor/features/on_boarding/domain/entities/user_data_entity.dart';

import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/entities/ob_boarding_verify_otp_entity.dart';
import '../../../domain/entities/on_boarding_send_otp_entity.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  String? phoneNumber, key, otp, countryCode;
  OnBoardingUseCase useCase;

  OtpBloc({required this.useCase}) : super(OtpInitial()) {
    on<PhoneNumberSaveEvent>(_onPhoneNumberSaved);
    on<PhoneOtpValidatorEvent>(_onVerifyValidOtp);
    on<PhoneOtpVerifyEvent>(_onVerifyOtpFn);
    on<SendOtpEvent>(_onResendOtp);
    on<GetUserJourneyEvent>(_getUserJourney);
  }

  _onPhoneNumberSaved(PhoneNumberSaveEvent event, Emitter<OtpState> emit) {
    phoneNumber = event.phoneNumber;
    countryCode = event.countryCode;
    key = event.key;
    emit(const FailureOtpState(""));
  }

  _onVerifyValidOtp(PhoneOtpValidatorEvent event, Emitter<OtpState> emit) {
    if (event.otp.length == 6) {
      otp = event.otp;
      emit(OtpValidState());
    } else if (event.otp.length < 6) {
      emit(OtpIncompleteState());
    }
  }

  _onVerifyOtpFn(PhoneOtpVerifyEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());

    var deviceId = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);

    OnBoardingVerifyOtpEntity entity = OnBoardingVerifyOtpEntity(
        otp: otp ?? event.otp, key: key ?? event.key, deviceId: deviceId, countryCode: countryCode);

    try {
      await useCase.verifyOtpOnBoarding(entity);

      add(const GetUserJourneyEvent());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles the form submission event.
  _onResendOtp(SendOtpEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    OnBoardingSendOtpEntity? entity = OnBoardingSendOtpEntity(
      phoneNumber: phoneNumber ?? event.phoneNumber,
    );
    try {
      String res = await useCase.call(params: entity);
      key = res;
      emit(ResendOtpSubmitted());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  /*Future<void> _getUserJourney(
      GetUserJourneyEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    try {
      await useCase.getUserJourney();
      //await useCase.getAssignedRoleUserData();
      //AppServices.navState.currentContext?.read<WalletDataBloc>().getWalletData();
      emit(SuccessOtpState());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }*/

  Future<void> _getUserJourney(GetUserJourneyEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    try {
      UserDataEntity userDataEntity = await useCase.getUserData();
      sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.kycVerified, userDataEntity.kycStatus);
      sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.roleAssigned, userDataEntity.role == null ? false : true);
      sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isMpinCreated, userDataEntity.mPin);

      String categoryJson = sl<SharedPreferencesHelper>().getString(PrefConstKeys.listOfCategory);
      if (categoryJson.isEmpty || categoryJson == "NA") {
        String categoriesJson = jsonEncode(userDataEntity.categories.map((e) => e.toJson()).toList());
        debugPrint('Category JSON.... $categoriesJson');
        await sl<SharedPreferencesHelper>().setString(PrefConstKeys.listOfCategory, categoriesJson);
      }

      String domainJson = sl<SharedPreferencesHelper>().getString(PrefConstKeys.savedDomainsNames);
      if (domainJson.isEmpty || domainJson == "NA") {
        List<String> domains = userDataEntity.domains.map((entity) => entity.domain).toList();

        String domainsNamesToJson = json.encode(domains);
        await sl<SharedPreferencesHelper>().setString(PrefConstKeys.savedDomainsNames, domainsNamesToJson);
      }

      sl<SharedPreferencesHelper>()
          .setString(PrefConstKeys.selectedRole, userDataEntity.role?.type ?? PrefConstKeys.seekerKey);

      sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.role}Done', true);
      sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.focus}Done', true);
      sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.category}Done', true);

      if (userDataEntity.kycStatus) {
        sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.kyc}Done', true);
        sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isHomeOpen, true);
      }
      //await useCase.getAssignedRoleUserData();
      //AppServices.navState.currentContext?.read<WalletDataBloc>().getWalletData();
      emit(SuccessOtpState());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }
}
