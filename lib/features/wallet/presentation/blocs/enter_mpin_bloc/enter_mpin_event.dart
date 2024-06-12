part of 'enter_mpin_bloc.dart';

sealed class EnterMPinEvent extends Equatable {
  const EnterMPinEvent();

  @override
  List<Object> get props => [];
}

class MPinValidatorEvent extends EnterMPinEvent {
  final String mPIn;

  const MPinValidatorEvent({required this.mPIn});
}

class MPinVerifyEvent extends EnterMPinEvent {
  final String mPin;

  const MPinVerifyEvent({required this.mPin});
}

class MPinInitialEvent extends EnterMPinEvent {
  const MPinInitialEvent();
}
