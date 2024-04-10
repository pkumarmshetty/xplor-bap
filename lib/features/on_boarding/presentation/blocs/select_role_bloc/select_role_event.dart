import 'package:equatable/equatable.dart';

/// Event class for the SelectRoleBloc.
sealed class SelectRoleEvent extends Equatable {
  const SelectRoleEvent();

  @override
  List<Object> get props => [];
}

/// Event class for the SelectRoleBloc.
class GetUserRolesEvent extends SelectRoleEvent {
  const GetUserRolesEvent();
}

/// Event class for the SelectRoleBloc.
class AssignRoleEvent extends SelectRoleEvent {
  const AssignRoleEvent();
}
