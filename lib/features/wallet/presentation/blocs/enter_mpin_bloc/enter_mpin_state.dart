part of 'enter_mpin_bloc.dart';

/// Base class for MPIN related states.
/// Extends [Equatable] for equality comparison.
sealed class EnterMPinState extends Equatable {
  const EnterMPinState();

  @override
  List<Object> get props => [];
}

/// Initial state when MPIN entry begins.
final class MPinInitial extends EnterMPinState {}

/// State indicating that the entered MPIN is valid.
final class MPinValidState extends EnterMPinState {}

/// State indicating that the entered MPIN is incomplete.
final class MPinIncompleteState extends EnterMPinState {}

/// State indicating that the MPIN verification process is in progress.
final class MPinLoadingState extends EnterMPinState {}

/// State indicating that the MPIN verification was successful.
final class SuccessMPinState extends EnterMPinState {}

/// State indicating that the MPIN verification failed.
final class FailureMPinState extends EnterMPinState {
  final String? message;

  const FailureMPinState(this.message);

  @override
  List<Object> get props => [message!];
}
