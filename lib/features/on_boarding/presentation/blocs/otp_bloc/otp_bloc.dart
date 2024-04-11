import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_utils.dart';
import '../../../domain/entities/ob_boarding_verify_otp_entity.dart';
import '../../../domain/entities/on_boarding_send_otp_entity.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';

part 'otp_event.dart';

part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  String phoneNumber = "";
  String key = "";
  String otp = "";

  OtpBloc() : super(OtpInitial()) {
    on<PhoneNumberSaveEvent>(_onPhoneNumberSaved);
    on<PhoneOtpValidatorEvent>(_onVerifyValidOtp);
    on<PhoneOtpVerifyEvent>(_onVerifyOtpFn);
    on<SendOtpEvent>(_onResendOtp);
    on<GetUserJourneyEvent>(_getUserJourney);
  }

  _onPhoneNumberSaved(PhoneNumberSaveEvent event, Emitter<OtpState> emit) {
    phoneNumber = event.phoneNumber;
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
    AppUtils.closeKeyword;
    emit(OtpLoadingState());

    OnBoardingVerifyOtpEntity entity = OnBoardingVerifyOtpEntity(otp: otp, key: key);

    try {
      await sl<OnBoardingUseCase>().verifyOtpOnBoarding(entity);

      add(const GetUserJourneyEvent());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles the form submission event.
  _onResendOtp(SendOtpEvent event, Emitter<OtpState> emit) async {
    AppUtils.closeKeyword;
    emit(OtpLoadingState());
    OnBoardingSendOtpEntity? entity = OnBoardingSendOtpEntity(
      phoneNumber: phoneNumber,
    );
    try {
      String res = await sl<OnBoardingUseCase>().call(params: entity);
      key = res;
      emit(ResendOtpSubmitted());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  Future<void> _getUserJourney(GetUserJourneyEvent event, Emitter<OtpState> emit) async {
    emit(OtpLoadingState());
    try {
      await sl<OnBoardingUseCase>().getUserJourney();

      emit(SuccessOtpState());
    } catch (e) {
      emit(FailureOtpState(AppUtils.getErrorMessage(e.toString())));
    }
  }
}
