import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/on_boarding_assign_role_model.dart';

void main() {
  group('OnBoardingAssignRoleModel JSON Serialization', () {
    test('fromJson should convert a JSON map to a OnBoardingAssignRoleModel object', () {
      // Arrange
      final jsonMap = {'roleId': 'roleId'};

      // Act
      final model = OnBoardingAssignRoleModel.fromJson(jsonMap);

      // Assert
      expect(model.roleId, 'roleId');
    });

    test('toJson should convert a OnBoardingAssignRoleModel object to a JSON map', () {
      // Arrange
      final model = OnBoardingAssignRoleModel(roleId: 'roleId');

      // Act
      final jsonMap = model.toJson();

      // Assert
      expect(jsonMap['roleId'], 'roleId');
    });

    test('fromJson and toJson should be symmetric', () {
      // Arrange
      final jsonMap = {'roleId': 'roleId'};

      // Act
      final model = OnBoardingAssignRoleModel.fromJson(jsonMap);
      final newJsonMap = model.toJson();

      // Assert
      expect(newJsonMap, jsonMap);
    });
  });
}
