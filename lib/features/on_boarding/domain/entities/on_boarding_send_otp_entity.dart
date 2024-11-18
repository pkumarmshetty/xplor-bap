import 'dart:convert';

/// Converts a JSON string to a [OnBoardingSendOtpEntity] object.
OnBoardingSendOtpEntity authEntityFromJson(String str) => OnBoardingSendOtpEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingSendOtpEntity] object to a JSON string.
String authEntityToJson(OnBoardingSendOtpEntity data) => json.encode(data.toJson());

class OnBoardingSendOtpEntity {
  String? phoneNumber;
  String? deviceId;
  bool? userCheck;

  OnBoardingSendOtpEntity({
    this.phoneNumber,
    this.deviceId,
    this.userCheck,
  });

  /// Creates a [OnBoardingSendOtpEntity] object from a JSON map.
  factory OnBoardingSendOtpEntity.fromJson(Map<String, dynamic> json) => OnBoardingSendOtpEntity(
        phoneNumber: json["phoneNumber"],
        deviceId: json["deviceId"],
        userCheck: json["userCheck"],
      );

  /// Converts the [OnBoardingSendOtpEntity] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'deviceId': deviceId,
      'userCheck': userCheck,
    };
  }
}
