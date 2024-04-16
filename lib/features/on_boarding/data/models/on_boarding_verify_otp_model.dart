import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';

class OnBoardingVerifyOtpModel extends OnBoardingVerifyOtpEntity {

  OnBoardingVerifyOtpModel({
    super.otp,
    super.key,
  });

  /// Creates a [OnBoardingVerifyOtpEntity] object from a JSON map.
  factory OnBoardingVerifyOtpModel.fromJson(Map<String, dynamic> json) => OnBoardingVerifyOtpModel(
    otp: json["otp"],
    key: json["key"],
  );

  /// Converts the [OnBoardingVerifyOtpEntity] object to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'otp': otp,
    };
  }
}