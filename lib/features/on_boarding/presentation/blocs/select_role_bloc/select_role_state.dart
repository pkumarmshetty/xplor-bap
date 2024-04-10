import 'package:equatable/equatable.dart';
import '../../../domain/entities/on_boarding_user_role_entity.dart';
import '../../../../../const/app_state.dart';

/// State class for the SelectRoleBloc.
sealed class SelectRoleState extends Equatable {
  const SelectRoleState();

  @override
  List<Object> get props => [];
}

/// Initial State class for the SelectRoleBloc.
final class SelectRoleInitial extends SelectRoleState {}

/// Loading state
class SelectRoleLoadingState extends SelectRoleState {
  final AppPageStatus status;

  const SelectRoleLoadingState({this.status = AppPageStatus.loading});

  @override
  List<Object> get props => [status];

  SelectRoleLoadingState copyWith({
    AppPageStatus? status,
  }) {
    return SelectRoleLoadingState(
      status: status ?? this.status,
    );
  }
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

  SelectRoleLoadedState copyWith({
    List<OnBoardingUserRoleEntity>? userRoles,
    AppPageStatus? status,
  }) {
    return SelectRoleLoadedState(
      userRoles: userRoles ?? this.userRoles,
      status: status ?? this.status,
    );
  }
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

  SelectRoleErrorState copyWith({
    String? errorMessage,
    AppPageStatus? status,
  }) {
    return SelectRoleErrorState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}

/// Navigation state
class SelectRoleNavigationState extends SelectRoleState {}
