import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/entities/on_boarding_send_otp_entity.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';

part 'phone_event.dart';

part 'phone_state.dart';

class PhoneBloc extends Bloc<PhoneEvent, PhoneState> {
  String? countryCode = "";
  OnBoardingUseCase useCase;

  PhoneBloc({required this.useCase}) : super(PhoneInitial()) {
    on<CountryCodeEvent>(_onCountryCodeChange);
    on<CheckPhoneEvent>(_validatePhoneNumber);
    on<PhoneSubmitEvent>(_onFormSubmitted);
    on<PhoneInitialEvent>(_onInitialEvent);
  }

  Future<void> _onCountryCodeChange(CountryCodeEvent event, Emitter<PhoneState> emit) async {
    countryCode = event.countryCode;
  }

  _validatePhoneNumber(CheckPhoneEvent event, Emitter<PhoneState> emit) {
    if (_checkPhone(event.phone.trim())) {
      emit(PhoneValidState());
    } else {
      emit(PhoneInvalidState());
    }
  }

  /// Handles the form submission event.
  _onFormSubmitted(PhoneSubmitEvent event, Emitter<PhoneState> emit) async {
    emit(PhoneLoadingState());

    OnBoardingSendOtpEntity? entity = OnBoardingSendOtpEntity(
      phoneNumber: '$countryCode ${event.phone}'.trim(),
      deviceId: sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
      userCheck: event.userCheck,
    );
    AppUtils.printLogs('$countryCode ${event.phone}'.trim());
    try {
      String res = await useCase.call(params: entity);
      emit(SuccessPhoneState(phoneNumber: '$countryCode ${event.phone}', key: res));
    } catch (e) {
      emit(FailurePhoneState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onInitialEvent(PhoneInitialEvent event, Emitter<PhoneState> emit) {
    emit(PhoneInitial());
  }
}

bool _checkPhone(String phone) {
  var phoneNumber = phone.replaceAll(' ', '');
  if (phoneNumber.length < 6 || phoneNumber.length > 16) {
    return false;
  } else if (phoneNumber.startsWith('0')) {
    return false;
  }
  return true;
}
