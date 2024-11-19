import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_entity.dart';

void main() {
  group('OnBoardingEntity JSON Serialization', () {
    test('authEntityFromJson should convert a JSON string to a OnBoardingEntity object', () {
      // Arrange
      const jsonString = '{"phoneNumber": "1234567890", "countryCode": "+1"}';

      // Act
      final entity = authEntityFromJson(jsonString);

      // Assert
      expect(entity.phoneNumber, "1234567890");
      expect(entity.countryCode, "+1");
    });

    test('authEntityToJson should convert a OnBoardingEntity object to a JSON string', () {
      // Arrange
      final entity = OnBoardingEntity(phoneNumber: "1234567890", countryCode: "+1");

      // Act
      final jsonString = authEntityToJson(entity);
      final decoded = json.decode(jsonString);

      // Assert
      expect(decoded['phoneNumber'], "1234567890");
      expect(decoded['countryCode'], "+1");
    });
  });
}
