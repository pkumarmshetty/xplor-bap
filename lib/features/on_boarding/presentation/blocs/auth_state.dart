import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart'; // Import the user role entity

import '../../../../../const/app_state.dart';
import '../../../../../const/base_bloc.dart';

/// Represents the state of the Bank Details feature.
class AuthState {
  const AuthState({
    this.loginNumber = const BlocFormItem(error: 'Please enter phone number'),
    this.status = AppPageStatus.initial,
    this.verificationCode = const BlocFormItem(error: null),
    this.countryCode,
    this.errorMessage,
    this.formKey,
    this.isNumberValid,
    this.userRoles, // Add user roles field
  });

  final String? errorMessage;
  final BlocFormItem loginNumber, verificationCode;
  final CountryCode? countryCode;
  final AppPageStatus? status;
  final GlobalKey<FormState>? formKey;
  final bool? isNumberValid;
  final List<OnBoardingUserRoleEntity>? userRoles; // Define user roles field

  /// Creates a new [BankDetailsState] with the specified changes.
  AuthState copyWith({
    BlocFormItem? loginNumber,
    CountryCode? countryCode,
    BlocFormItem? verificationCode,
    String? errorMessage,
    AppPageStatus? status,
    GlobalKey<FormState>? formKey,
    bool? isNumberValid,
    List<OnBoardingUserRoleEntity>?
        userRoles, // Include user roles field in copyWith
  }) {
    return AuthState(
      loginNumber: loginNumber ?? this.loginNumber,
      countryCode: countryCode ?? this.countryCode,
      errorMessage: errorMessage ?? this.errorMessage,
      verificationCode: verificationCode ?? this.verificationCode,
      status: status ?? this.status,
      formKey: formKey,
      isNumberValid: isNumberValid ?? false,
      userRoles: userRoles ?? this.userRoles, // Update user roles field
    );
  }
}

class NavigationState extends AuthState {
  final OnBoardingEntity? data;

  NavigationState(this.data);
}
