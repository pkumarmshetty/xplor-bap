import '../../domain/entities/on_boarding_send_otp_entity.dart';

class OnBoardingSendOtpModel extends OnBoardingSendOtpEntity {
  OnBoardingSendOtpModel({
    super.phoneNumber,
  });

  /// Creates a [OnBoardingSendOtpEntity] object from a JSON map.
  factory OnBoardingSendOtpModel.fromJson(Map<String, dynamic> json) => OnBoardingSendOtpModel(
        phoneNumber: json["phoneNumber"],
      );

  /// Converts the [OnBoardingSendOtpEntity] object to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
    };
  }
}
