import 'package:equatable/equatable.dart';
import '../../../domain/entities/on_boarding_user_role_entity.dart';
import '../../../../../const/app_state.dart';

enum RoleState { loading, loaded, saved, failure }

/// State class for the SelectRoleBloc.
sealed class SelectRoleState extends Equatable {
  const SelectRoleState();

  @override
  List<Object> get props => [];
}

/// Initial State class for the SelectRoleBloc.
final class SelectRoleInitial extends SelectRoleState {}

/// Loading state
class SelectRoleFetchedState extends SelectRoleState {
  final List<OnBoardingUserRoleEntity> userRoles;
  final RoleState status;

  const SelectRoleFetchedState({required this.userRoles, this.status = RoleState.loading});

  @override
  List<Object> get props => [status];
}

/// Loaded state
class SelectRoleLoadedState extends SelectRoleState {
  final List<OnBoardingUserRoleEntity> userRoles;
  final AppPageStatus status;

  const SelectRoleLoadedState({
    required this.userRoles,
    this.status = AppPageStatus.success,
  });

  @override
  List<Object> get props => [userRoles, status];
}

/// Error state
class SelectRoleErrorState extends SelectRoleState {
  final String errorMessage;
  final AppPageStatus status;

  const SelectRoleErrorState({
    required this.errorMessage,
    this.status = AppPageStatus.error,
  });

  @override
  List<Object> get props => [errorMessage, status];
}
