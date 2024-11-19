part of 'mpin_bloc.dart';

abstract class MpinState extends Equatable {
  const MpinState();

  @override
  List<Object> get props => [];
}

class MpinInitial extends MpinState {
  const MpinInitial() : super();

  @override
  String toString() => 'PinConfirmationInitial';
}

class PinCompletedState extends MpinState {
  const PinCompletedState() : super();
}

class ConfirmPinUpdatedState extends MpinState {
  const ConfirmPinUpdatedState({required String pin}) : super();
}

class PinSuccessState extends MpinState {
  final String confirmedPin;
  const PinSuccessState(this.confirmedPin) : super();
}

class PinFailedState extends MpinState {
  final String errorMessage;
  const PinFailedState({required this.errorMessage}) : super();
}

class PinsLoadingState extends MpinState {
  const PinsLoadingState() : super();
}

class PinsMisMatchedState extends MpinState {
  final String errorMessage;
  const PinsMisMatchedState({required this.errorMessage}) : super();
}
