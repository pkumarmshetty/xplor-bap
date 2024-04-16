import 'package:xplor/features/on_boarding/domain/entities/on_boarding_entity.dart';

class OnBoardingModel extends OnBoardingEntity {

  OnBoardingModel({
    super.phoneNumber,
    super.countryCode,
  });

  /// Creates a [OnBoardingEntity] object from a JSON map.
  factory OnBoardingModel.fromJson(Map<String, dynamic> json) => OnBoardingModel(
    phoneNumber: json["phoneNumber"],
    countryCode: json["countryCode"],
  );

  /// Converts the [OnBoardingEntity] object to a JSON map.
  @override
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
    };
  }
}
