import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/onboarding_model.dart';

void main() {
  group('OnBoardingModel JSON Serialization', () {
    test('fromJson should convert a JSON map to a OnBoardingModel object', () {
      // Arrange
      final jsonMap = {
        "phoneNumber": "1234567890",
        "countryCode": "+1",
      };

      // Act
      final model = OnBoardingModel.fromJson(jsonMap);

      // Assert
      expect(model.phoneNumber, "1234567890");
      expect(model.countryCode, "+1");
    });

    test('toJson should convert a OnBoardingModel object to a JSON map', () {
      // Arrange
      final model = OnBoardingModel(
        phoneNumber: "1234567890",
        countryCode: "+1",
      );

      // Act
      final jsonMap = model.toJson();

      // Assert
      expect(jsonMap['phoneNumber'], "1234567890");
      expect(jsonMap['countryCode'], "+1");
    });
  });
}
