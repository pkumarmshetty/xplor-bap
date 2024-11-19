import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';

void main() {
  group('OnBoardingAssignRoleEntity JSON Serialization', () {
    test('authEntityFromJson should convert a JSON string to a OnBoardingAssignRoleEntity object', () {
      // Arrange
      const jsonString = '{"roleId": "123"}';

      // Act
      final entity = authEntityFromJson(jsonString);

      // Assert
      expect(entity.roleId, "123");
    });

    test('authEntityToJson should convert a OnBoardingAssignRoleEntity object to a JSON string', () {
      // Arrange
      final entity = OnBoardingAssignRoleEntity(roleId: "123");

      // Act
      final jsonString = authEntityToJson(entity);
      final decoded = json.decode(jsonString);

      // Assert
      expect(decoded['roleId'], "123");
    });
  });
}
