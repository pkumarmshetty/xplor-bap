part of 'phone_bloc.dart';

sealed class PhoneEvent {
  const PhoneEvent();
}

class PhoneSubmitEvent extends PhoneEvent {
  final String phone;
  final bool userCheck;

  const PhoneSubmitEvent({required this.phone, required this.userCheck});

  List<Object> get props => [phone, userCheck];
}

class PhoneInitialEvent extends PhoneEvent {
  const PhoneInitialEvent();

  List<Object> get props => [];
}

class CheckPhoneEvent extends PhoneEvent {
  final String phone;

  const CheckPhoneEvent({required this.phone});
}

class CountryCodeEvent extends PhoneEvent {
  const CountryCodeEvent({required this.countryCode});

  final String countryCode;
}
