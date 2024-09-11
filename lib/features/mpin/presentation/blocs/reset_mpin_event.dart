part of 'reset_mpin_bloc.dart';

abstract class ResetMpinEvent extends Equatable {
  const ResetMpinEvent();
}

class ResetMpinOtpEvent extends ResetMpinEvent {
  @override
  List<Object?> get props => [];
}

class ResetMpinApiEvent extends ResetMpinEvent {
  final String pin1;
  final String pin2;

  @override
  List<Object?> get props => [];

  const ResetMpinApiEvent({
    required this.pin1,
    required this.pin2,
  });
}

class VerifyOtpEvent extends ResetMpinEvent {
  final String otp;

  @override
  List<Object?> get props => [];

  const VerifyOtpEvent({
    required this.otp,
  });
}

class MpinOtpChangedEvent extends ResetMpinEvent {
  final String otp;

  @override
  List<Object?> get props => [];

  const MpinOtpChangedEvent({
    required this.otp,
  });
}

class ResetMpinChangedEvent extends ResetMpinEvent {
  final String originalPin;
  final String confirmPin;

  const ResetMpinChangedEvent({required this.originalPin, required this.confirmPin});

  @override
  List<Object?> get props => [];
}
