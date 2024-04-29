import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';

void main() {
  group('OnBoardingSendOtpEntity JSON Serialization', () {
    test('authEntityFromJson should convert a JSON string to a OnBoardingSendOtpEntity object', () {
      // Arrange
      const jsonString = '{"phoneNumber": "1234567890"}';

      // Act
      final entity = authEntityFromJson(jsonString);

      // Assert
      expect(entity.phoneNumber, "1234567890");
    });

    test('authEntityToJson should convert a OnBoardingSendOtpEntity object to a JSON string', () {
      // Arrange
      final entity = OnBoardingSendOtpEntity(phoneNumber: "1234567890");

      // Act
      final jsonString = authEntityToJson(entity);
      final decoded = json.decode(jsonString);

      // Assert
      expect(decoded['phoneNumber'], "1234567890");
    });
  });
}
