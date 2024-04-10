import 'package:bloc/bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/auth_event.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/auth_state.dart';

import '../../../../config/services/app_services.dart';
import '../../../../const/app_state.dart';
import '../../../../const/base_bloc.dart';
import '../../../../const/local_storage/pref_const_key.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/extensions/validation.dart';
import '../../domain/entities/on_boarding_entity.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final formKey = GlobalKey<FormState>();
  bool updateKyc = false;
  OnBoardingEntity? entity;

  /// Constructor for creating an instance of CompleteProfileBloc.
  AuthBloc() : super(const AuthState()) {
    on<AuthInitEvent>(_initState);
    on<AuthPhoneNameEvent>(_onPhoneChanged);
    on<AuthCountryCodeName>(_onCountryCodeChange);
    on<AuthSubmitEvent>(_onFormSubmitted);
    on<NavigationEvent>(_handleNavigationEvent);
    on<ResentOtpEvent>(resentOtp);
    on<AuthOtpNameEvent>(_onOtpChanged);
    on<AuthSubmitOtpEvent>(_onOtpSubmit);
    on<AuthGetUserJourneyEvent>(_getUserJourney);
    on<AuthAssignRoleEvent>(_onAssignRoleSubmit);
    on<AuthGetUserRolesEvent>(_onGetUserRoles);
  }

  /// Handles the initialization event for CompleteProfileBloc.
  Future<void> _initState(AuthInitEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(
      formKey: formKey,
    ));
  }

  /// Handles the name changed event.
  Future<void> _onPhoneChanged(
      AuthPhoneNameEvent event, Emitter<AuthState> emit) async {
    String? phone = event.phone.value;
    emit(
      state.copyWith(
        loginNumber: BlocFormItem(
          value: phone,
          error: phone?.getValidationError(ValidationType.phone),
        ),
        isNumberValid:
            phone?.getValidationError(ValidationType.phone)?.toString() == null
                ? true
                : false,
        formKey: formKey,
      ),
    );
  }

  Future<void> _onCountryCodeChange(
      AuthCountryCodeName event, Emitter<AuthState> emit) async {
    CountryCode? countryCode = event.countryCode;
    emit(
      state.copyWith(
        isNumberValid: state.isNumberValid,
        countryCode: countryCode,
        formKey: formKey,
      ),
    );
  }

  /// Handles the otp changed event.
  Future<void> _onOtpChanged(
      AuthOtpNameEvent event, Emitter<AuthState> emit) async {
    String? otp = event.otp.value;
    emit(
      state.copyWith(
        verificationCode: BlocFormItem(
          value: otp,
          error: null,
        ),
        isNumberValid: otp?.length == 6,
        //formKey: formKey,
      ),
    );
  }

  /// Handles the form submission event.
  Future<void> _onFormSubmitted(
      AuthSubmitEvent event, Emitter<AuthState> emit) async {
    if (event.isResend ? true : state.formKey!.currentState!.validate()) {
      OnBoardingSendOtpEntity entity = OnBoardingSendOtpEntity(
        phoneNumber:
           event.isResend
            ? event.phoneNumber.replaceAll(' ', '')
            : '${state.countryCode!.dialCode!.toString()}${state.loginNumber.value}'
                .replaceAll(' ', ''),
      );

      AppUtils.closeKeyword;
      emit(state.copyWith(status: AppPageStatus.loading));

      try {
        await sl<OnBoardingUseCase>().call(params: entity);
        emit(state.copyWith(status: AppPageStatus.success));

        if (!event.isResend) {
          this.entity = OnBoardingEntity(
            phoneNumber: state.loginNumber.value?.replaceAll(' ', ''),
            countryCode: state.countryCode!.dialCode!.toString(),
          );
          add(NavigationEvent());
        }
      } catch (e) {
        AppUtils.showSnackBar(
            AppServices.navState.currentContext!, e.toString());
        emit(state.copyWith(
          status: AppPageStatus.finish,
        ));
      }
    }
  }

  /// Handles the otp submit event.
  Future<void> _onOtpSubmit(
      AuthSubmitOtpEvent event, Emitter<AuthState> emit) async {
    OnBoardingVerifyOtpEntity entity = OnBoardingVerifyOtpEntity(
        otp: state.verificationCode.value,
        key: SharedPreferencesHelper().getString(PrefConstKeys.userKey));
    AppUtils.closeKeyword;
    emit(state.copyWith(status: AppPageStatus.loading));

    try {
      await sl<OnBoardingUseCase>().verifyOtpOnBoarding(entity);
      emit(state.copyWith(status: AppPageStatus.success));
      add(const AuthGetUserJourneyEvent());
    } catch (e) {
      //AppUtils.showSnackBar(AppServices.navState.currentContext!, e.toString());
      emit(state.copyWith(
          status: AppPageStatus.finish, errorMessage: e.toString()));
    }
  }

  Future<void> _getUserJourney(
      AuthGetUserJourneyEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppPageStatus.loading));

    try {
      await sl<OnBoardingUseCase>().getUserJourney();
      emit(state.copyWith(status: AppPageStatus.success));
      add(NavigationEvent());
    } catch (e) {
      //AppUtils.showSnackBar(AppServices.navState.currentContext!, e.toString());
      emit(state.copyWith(
          status: AppPageStatus.finish, errorMessage: e.toString()));
    }
  }

  /// Handles the assign role submit event.
  Future<void> _onAssignRoleSubmit(
      AuthAssignRoleEvent event, Emitter<AuthState> emit) async {
    OnBoardingAssignRoleEntity entity = OnBoardingAssignRoleEntity(
      roleId: SharedPreferencesHelper().getString(PrefConstKeys.roleID),
    );
    emit(state.copyWith(status: AppPageStatus.loading));

    try {
      bool success = await sl<OnBoardingUseCase>().assignRoleOnBoarding(entity);
      success
          ? emit(state.copyWith(status: AppPageStatus.success))
          : throw Exception();
      add(NavigationEvent());
    } catch (e) {
      AppUtils.showSnackBar(AppServices.navState.currentContext!, e.toString());
      emit(state.copyWith(
        status: AppPageStatus.finish,
      ));
    }
  }

  /// Handles the get user roles submit event.
  Future<void> _onGetUserRoles(
    AuthGetUserRolesEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AppPageStatus.loading));
    try {
      final userRoles = await sl<OnBoardingUseCase>().getUserRolesOnBoarding();
      emit(state.copyWith(userRoles: userRoles, status: AppPageStatus.success));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: AppPageStatus.finish));
    }
  }

  Future<void> resentOtp(ResentOtpEvent event, Emitter<AuthState> emit) async {
    AppUtils.closeKeyword;
    emit(state.copyWith(status: AppPageStatus.loading, errorMessage: ""));

    try {
      await sl<OnBoardingUseCase>().resendOtpOnBoarding();
      emit(state.copyWith(status: AppPageStatus.success));
    } catch (e) {
      AppUtils.showSnackBar(AppServices.navState.currentContext!, e.toString());
      emit(state.copyWith(
        status: AppPageStatus.finish,
      ));
    }
  }

  Future<void> _handleNavigationEvent(
      NavigationEvent event, Emitter<AuthState> emit) async {
    // Create an instance of OnBoardingEntity with the necessary data

    // Emit a NavigationState with the created entity
    emit(NavigationState(entity));
  }
}
