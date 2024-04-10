import 'package:country_code_picker/country_code_picker.dart';
import 'package:equatable/equatable.dart';

import '../../../../const/base_bloc.dart';

/// Abstract base class for events related to CompleteProfile feature.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event triggered when the CompleteProfile form is submitted.
class AuthSubmitEvent extends AuthEvent {
  const AuthSubmitEvent({this.isResend = false,this.phoneNumber=""});
  final bool isResend;
  final String phoneNumber;

  @override
  List<Object> get props => [isResend,phoneNumber];
}

class AuthSubmitOtpEvent extends AuthEvent {
  const AuthSubmitOtpEvent();
}

class AuthAssignRoleEvent extends AuthEvent {
  const AuthAssignRoleEvent();
}

class AuthGetUserRolesEvent extends AuthEvent {
  const AuthGetUserRolesEvent();
}

class AuthGetUserJourneyEvent extends AuthEvent {
  const AuthGetUserJourneyEvent();
}

/// Event triggered when the CompleteProfile is initialized.
class AuthInitEvent extends AuthEvent {
  const AuthInitEvent();
}

/// Event triggered when the CompleteProfile name is changed.
class AuthPhoneNameEvent extends AuthEvent {
  const AuthPhoneNameEvent({required this.phone});

  final BlocFormItem phone;

  @override
  List<Object> get props => [phone];
}

class AuthCountryCodeName extends AuthEvent {
  const AuthCountryCodeName({required this.countryCode});

  final CountryCode countryCode;

  @override
  List<Object> get props => [countryCode];
}

class AuthOtpNameEvent extends AuthEvent {
  const AuthOtpNameEvent({required this.otp});

  final BlocFormItem otp;

  @override
  List<Object> get props => [otp];
}

class NavigationEvent extends AuthEvent {}

class ResentOtpEvent extends AuthEvent {}
