part of 'otp_bloc.dart';

sealed class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

final class OtpInitial extends OtpState {}

final class OtpValidState extends OtpState {}

final class OtpInvalidState extends OtpState {}

final class OtpIncompleteState extends OtpState {}

final class SendingOtpEventState extends OtpState {}

final class OtpLoadingState extends OtpState {}

final class SuccessOtpState extends OtpState {}

final class ResendOtpSubmitted extends OtpState {}

final class FailureOtpState extends OtpState {
  final String? message;

  const FailureOtpState(this.message);
}
