import 'dart:convert';

/// Converts a JSON string to a [OnBoardingAssignRoleEntity] object.
OnBoardingAssignRoleEntity authEntityFromJson(String str) => OnBoardingAssignRoleEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingAssignRoleEntity] object to a JSON string.
String authEntityToJson(OnBoardingAssignRoleEntity data) => json.encode(data.toJson());

class OnBoardingAssignRoleEntity {
  String? roleId;

  OnBoardingAssignRoleEntity({
    this.roleId,
  });

  /// Creates a [OnBoardingAssignRoleEntity] object from a JSON map.
  factory OnBoardingAssignRoleEntity.fromJson(Map<String, dynamic> json) => OnBoardingAssignRoleEntity(
        roleId: json["roleId"],
      );

  /// Converts the [OnBoardingAssignRoleEntity] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
    };
  }
}
