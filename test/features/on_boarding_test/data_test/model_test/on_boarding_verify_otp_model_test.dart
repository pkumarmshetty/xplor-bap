import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/on_boarding_verify_otp_model.dart';

void main() {
  group('OnBoardingVerifyOtpModel JSON Serialization', () {
    test('fromJson should convert a JSON map to a OnBoardingVerifyOtpModel object', () {
      // Arrange
      final jsonMap = {
        "otp": "123456",
        "key": "abc123",
      };

      // Act
      final model = OnBoardingVerifyOtpModel.fromJson(jsonMap);

      // Assert
      expect(model.otp, "123456");
      expect(model.key, "abc123");
    });

    test('toJson should convert a OnBoardingVerifyOtpModel object to a JSON map', () {
      // Arrange
      final model = OnBoardingVerifyOtpModel(
        otp: "123456",
        key: "abc123",
      );

      // Act
      final jsonMap = model.toJson();

      // Assert
      expect(jsonMap['otp'], "123456");
      expect(jsonMap['key'], "abc123");
    });
  });
}
