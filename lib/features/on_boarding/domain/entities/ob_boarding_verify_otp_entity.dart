import 'dart:convert';

/// Converts a JSON string to a [OnBoardingVerifyOtpEntity] object.
OnBoardingVerifyOtpEntity authEntityFromJson(String str) => OnBoardingVerifyOtpEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingSendOtpEntity] object to a JSON string.
String authEntityToJson(OnBoardingVerifyOtpEntity data) => json.encode(data.toJson());

class OnBoardingVerifyOtpEntity {
  String? otp;
  String? key;

  OnBoardingVerifyOtpEntity({
    this.otp,
    this.key,
  });

  /// Creates a [OnBoardingVerifyOtpEntity] object from a JSON map.
  factory OnBoardingVerifyOtpEntity.fromJson(Map<String, dynamic> json) => OnBoardingVerifyOtpEntity(
        otp: json["otp"],
        key: json["key"],
      );

  /// Converts the [OnBoardingVerifyOtpEntity] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'otp': otp,
    };
  }
}
