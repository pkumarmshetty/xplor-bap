part of 'enter_mpin_bloc.dart';

/// Base class for MPIN related events.
/// Extends [Equatable] for equality comparison.
sealed class EnterMPinEvent extends Equatable {
  const EnterMPinEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered to validate the entered MPIN.
class MPinValidatorEvent extends EnterMPinEvent {
  final String mPIn;

  const MPinValidatorEvent({required this.mPIn});
}

/// Event triggered to verify the entered MPIN.
class MPinVerifyEvent extends EnterMPinEvent {
  final String mPin;

  const MPinVerifyEvent({required this.mPin});
}

/// Event triggered when the MPIN entry is initialized.
class MPinInitialEvent extends EnterMPinEvent {
  const MPinInitialEvent();
}
