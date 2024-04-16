import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';

void main() {
  group('OnBoardingVerifyOtpEntity JSON Serialization', () {
    test(
        'authEntityFromJson should convert a JSON string to a OnBoardingVerifyOtpEntity object',
        () {
      // Arrange
      const jsonString = '{"otp": "123456", "key": "abc123"}';

      // Act
      final entity = authEntityFromJson(jsonString);

      // Assert
      expect(entity.otp, "123456");
      expect(entity.key, "abc123");
    });

    test(
        'authEntityToJson should convert a OnBoardingVerifyOtpEntity object to a JSON string',
        () {
      // Arrange
      final entity = OnBoardingVerifyOtpEntity(otp: "123456", key: "abc123");

      // Act
      final jsonString = authEntityToJson(entity);
      final decoded = json.decode(jsonString);

      // Assert
      expect(decoded['otp'], "123456");
      expect(decoded['key'], "abc123");
    });
  });
}
