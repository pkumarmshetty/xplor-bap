import 'package:bloc/bloc.dart';
import 'select_role_event.dart';
import 'select_role_state.dart';
import '../../../../../const/app_state.dart';
import '../../../../../const/local_storage/pref_const_key.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../domain/entities/on_boarding_assign_role_entity.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';

/// Bloc for handling user role selection events.
class SelectRoleBloc extends Bloc<SelectRoleEvent, SelectRoleState> {
  SelectRoleBloc() : super(SelectRoleInitial()) {
    on<GetUserRolesEvent>(_onGetUserRoles);
    on<AssignRoleEvent>(_onAssignRoleSubmit);
  }

  /// Handles the get user roles submit event.
  Future<void> _onGetUserRoles(
    GetUserRolesEvent event,
    Emitter<SelectRoleState> emit,
  ) async {
    emit(const SelectRoleLoadingState(status: AppPageStatus.loading));
    try {
      final userRoles = await sl<OnBoardingUseCase>().getUserRolesOnBoarding();
      emit(SelectRoleLoadedState(userRoles: userRoles, status: AppPageStatus.success));
    } catch (e) {
      emit(SelectRoleErrorState(errorMessage: e.toString(), status: AppPageStatus.finish));
    }
  }

  /// Handles the assign role submit event.
  Future<void> _onAssignRoleSubmit(AssignRoleEvent event, Emitter<SelectRoleState> emit) async {
    OnBoardingAssignRoleEntity entity = OnBoardingAssignRoleEntity(
      roleId: sl<SharedPreferencesHelper>().getString(PrefConstKeys.roleID),
    );
    //emit(const SelectRoleLoadingState(status: AppPageStatus.loading));

    try {
      // Call the use case to assign the role
      final success = await sl<OnBoardingUseCase>().assignRoleOnBoarding(entity);

      if (success) {
        // Add NavigationEvent if successful
        emit(SelectRoleNavigationState());
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(SelectRoleErrorState(status: AppPageStatus.finish, errorMessage: e.toString()));
    }
  }
}
