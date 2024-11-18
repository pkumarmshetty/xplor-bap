part of 'mpin_bloc.dart';

abstract class MpinEvent extends Equatable {
  const MpinEvent();

  @override
  List<Object> get props => [];
}

class PinInitialEvent extends MpinEvent {
  const PinInitialEvent();
}

class PinChangedEvent extends MpinEvent {
  final String originalPin;
  final String confirmPin;

  const PinChangedEvent({required this.originalPin, required this.confirmPin});
}

class ConfirmPinChangedEvent extends MpinEvent {
  final String pin;

  const ConfirmPinChangedEvent(this.pin);
}

class ValidatePinsEvent extends MpinEvent {
  final String originalPin;
  final String confirmPin;

  const ValidatePinsEvent({required this.originalPin, required this.confirmPin});
}
// class PinSubmittedEvent extends MpinEvent {
//   final String mPin;
//
//   const PinSubmittedEvent(this.mPin);
// }
