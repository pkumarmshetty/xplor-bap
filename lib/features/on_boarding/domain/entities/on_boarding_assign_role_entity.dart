import 'dart:convert';

/// Converts a JSON string to a [OnBoardingAssignRoleEntity] object.
OnBoardingAssignRoleEntity authEntityFromJson(String str) => OnBoardingAssignRoleEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingAssignRoleEntity] object to a JSON string.
String authEntityToJson(OnBoardingAssignRoleEntity data) => json.encode(data.toJson());

class OnBoardingAssignRoleEntity {
  String? roleId;
  String? deviceId;

  OnBoardingAssignRoleEntity({
    this.roleId,
    this.deviceId,
  });

  /// Creates a [OnBoardingAssignRoleEntity] object from a JSON map.
  factory OnBoardingAssignRoleEntity.fromJson(Map<String, dynamic> json) => OnBoardingAssignRoleEntity(
        roleId: json["roleId"],
        deviceId: json["deviceId"],
      );

  /// Converts the [OnBoardingAssignRoleEntity] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'deviceId': deviceId,
    };
  }
}
