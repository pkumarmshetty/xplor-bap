part of 'phone_bloc.dart';

sealed class PhoneState extends Equatable {
  const PhoneState();

  @override
  List<Object> get props => [];
}

final class PhoneInitial extends PhoneState {}

final class PhoneValidState extends PhoneState {}

final class PhoneInvalidState extends PhoneState {}

final class PhoneLoadingState extends PhoneState {}

final class PhoneSubmittingState extends PhoneState {
  final String phoneNumber;

  const PhoneSubmittingState({
    required this.phoneNumber,
  });
}

final class SuccessPhoneState extends PhoneState {
  final String phoneNumber;
  final String key;

  const SuccessPhoneState({required this.phoneNumber, required this.key});
}

final class FailurePhoneState extends PhoneState {
  final String? message;

  const FailurePhoneState(this.message);
}
