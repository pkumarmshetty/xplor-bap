import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/onboarding_send_otp_model.dart';

void main() {
  group('OnBoardingSendOtpModel JSON Serialization', () {
    test(
        'fromJson should convert a JSON map to a OnBoardingSendOtpModel object',
        () {
      // Arrange
      final jsonMap = {
        "phoneNumber": "1234567890",
      };

      // Act
      final model = OnBoardingSendOtpModel.fromJson(jsonMap);

      // Assert
      expect(model.phoneNumber, "1234567890");
    });

    test('toJson should convert a OnBoardingSendOtpModel object to a JSON map',
        () {
      // Arrange
      final model = OnBoardingSendOtpModel(
        phoneNumber: "1234567890",
      );

      // Act
      final jsonMap = model.toJson();

      // Assert
      expect(jsonMap['phoneNumber'], "1234567890");
    });
  });
}
