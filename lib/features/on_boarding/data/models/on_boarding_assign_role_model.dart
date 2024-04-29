import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';

class OnBoardingAssignRoleModel extends OnBoardingAssignRoleEntity {
  OnBoardingAssignRoleModel({
    super.roleId,
  });

  /// Creates a [OnBoardingAssignRoleEntity] object from a JSON map.
  factory OnBoardingAssignRoleModel.fromJson(Map<String, dynamic> json) => OnBoardingAssignRoleModel(
        roleId: json["roleId"],
      );

  /// Converts the [OnBoardingAssignRoleEntity] object to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
    };
  }
}
