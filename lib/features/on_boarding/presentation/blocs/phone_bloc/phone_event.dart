part of 'phone_bloc.dart';

sealed class PhoneEvent {
  const PhoneEvent();
}

class PhoneSubmitEvent extends PhoneEvent {
  final String phone;

  const PhoneSubmitEvent({required this.phone});

  List<Object> get props => [phone];
}

class CheckPhoneEvent extends PhoneEvent {
  final String phone;

  const CheckPhoneEvent({required this.phone});
}

class CountryCodeEvent extends PhoneEvent {
  const CountryCodeEvent({required this.countryCode});

  final String countryCode;
}
