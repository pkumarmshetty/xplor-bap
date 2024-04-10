part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberSaveEvent extends OtpEvent {
  final String phoneNumber;
  final String key;

  const PhoneNumberSaveEvent({required this.phoneNumber, required this.key});
}

class PhoneOtpValidatorEvent extends OtpEvent {
  final String otp;

  const PhoneOtpValidatorEvent({required this.otp});
}

class PhoneOtpResendEvent extends OtpEvent {
  const PhoneOtpResendEvent();
}

class SendOtpEvent extends OtpEvent {
  const SendOtpEvent();
}

class GetUserJourneyEvent extends OtpEvent {
  const GetUserJourneyEvent();
}

class PhoneOtpVerifyEvent extends OtpEvent {
  final String otp;

  const PhoneOtpVerifyEvent({required this.otp});
}