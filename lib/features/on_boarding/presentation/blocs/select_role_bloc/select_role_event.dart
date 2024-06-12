import 'package:equatable/equatable.dart';

import '../../../domain/entities/on_boarding_assign_role_entity.dart';

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
  final OnBoardingAssignRoleEntity? entity;

  const AssignRoleEvent({this.entity});
}

class SaveRoleOnServerForBelem extends SelectRoleEvent {
  const SaveRoleOnServerForBelem();
}
