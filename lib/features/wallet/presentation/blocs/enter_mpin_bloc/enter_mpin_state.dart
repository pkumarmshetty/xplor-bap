part of 'enter_mpin_bloc.dart';

sealed class EnterMPinState extends Equatable {
  const EnterMPinState();

  @override
  List<Object> get props => [];
}

final class MPinInitial extends EnterMPinState {}

final class MPinValidState extends EnterMPinState {}

final class MPinIncompleteState extends EnterMPinState {}

final class MPinLoadingState extends EnterMPinState {}

final class SuccessMPinState extends EnterMPinState {}

final class FailureMPinState extends EnterMPinState {
  final String? message;

  const FailureMPinState(this.message);

  @override
  List<Object> get props => [message!];
}
