import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';

import '../../../../../const/app_state.dart';

import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';
import 'select_role_event.dart';
import 'select_role_state.dart';

/// Bloc for handling user role selection events.
class SelectRoleBloc extends Bloc<SelectRoleEvent, SelectRoleState> {
  OnBoardingUseCase useCase;
  List<OnBoardingUserRoleEntity> userRoles = [];

  SelectRoleBloc({required this.useCase}) : super(SelectRoleInitial()) {
    on<GetUserRolesEvent>(_onGetUserRoles);
    on<AssignRoleEvent>(_onAssignRoleSubmit);
    on<SaveRoleOnServerForBelem>(_onSaveRoleOnServerForBelem);
  }

  /// Handles the get user roles submit event.
  Future<void> _onGetUserRoles(
    GetUserRolesEvent event,
    Emitter<SelectRoleState> emit,
  ) async {
    userRoles.clear();
    emit(SelectRoleFetchedState(userRoles: userRoles, status: RoleState.loading));
    try {
      final userRoles = await useCase.getUserRolesOnBoarding();
      this.userRoles = userRoles;
      emit(SelectRoleFetchedState(userRoles: userRoles, status: RoleState.loaded));
    } catch (e) {
      emit(SelectRoleErrorState(errorMessage: e.toString(), status: AppPageStatus.finish));
    }
  }

  /// Handles the assign role submit event.
  Future<void> _onAssignRoleSubmit(AssignRoleEvent event, Emitter<SelectRoleState> emit) async {
    Map<String, dynamic> dataMap = <String, dynamic>{};
    dataMap['deviceId'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);
    dataMap['roleId'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.roleID);

    try {
      emit(SelectRoleFetchedState(userRoles: userRoles, status: RoleState.loading));
      // Call the use case to assign the role
      final success = await useCase.updateDevicePreference(dataMap);

      if (success) {
        // Add NavigationEvent if successful
        emit(SelectRoleFetchedState(userRoles: userRoles, status: RoleState.saved));
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(SelectRoleErrorState(status: AppPageStatus.finish, errorMessage: e.toString()));
    }
  }

  Future<FutureOr<void>> _onSaveRoleOnServerForBelem(
      SaveRoleOnServerForBelem event, Emitter<SelectRoleState> emit) async {
    try {
      final userRoles = await useCase.getUserRolesOnBoarding();
      String seekerId = userRoles.firstWhere((item) => item.type == PrefConstKeys.seekerKey).id.toString();
      debugPrint('The ID of the SEEKER is: $seekerId');

      Map<String, dynamic> dataMap = <String, dynamic>{};
      dataMap['deviceId'] = sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId);
      dataMap['roleId'] = seekerId;

      final success = await useCase.updateDevicePreference(dataMap);

      if (success) {
        debugPrint("Role assigning success");
        sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.role}Done', true);
        sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedRole, PrefConstKeys.seekerKey);
      } else {
        throw Exception();
      }
    } catch (e) {
      debugPrint("Role assigning error");
      //emit(SelectRoleErrorState(errorMessage: e.toString(), status: AppPageStatus.finish));
    }
  }
}
