import 'dart:convert';

/// Converts a JSON string to a [OnBoardingEntity] object.
OnBoardingEntity authEntityFromJson(String str) =>
    OnBoardingEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingEntity] object to a JSON string.
String authEntityToJson(OnBoardingEntity data) => json.encode(data.toJson());

class OnBoardingEntity {
  String? phoneNumber;
  String? countryCode;

  OnBoardingEntity({
    this.phoneNumber,
    this.countryCode,
  });

  /// Creates a [OnBoardingEntity] object from a JSON map.
  factory OnBoardingEntity.fromJson(Map<String, dynamic> json) =>
      OnBoardingEntity(
        phoneNumber: json["phoneNumber"],
        countryCode: json["countryCode"],
      );

  /// Converts the [OnBoardingEntity] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
    };
  }
}
