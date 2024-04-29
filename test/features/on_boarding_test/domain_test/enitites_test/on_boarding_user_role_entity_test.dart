import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';

void main() {
  group('OnBoardingUserRoleEntity JSON Serialization', () {
    test('onBoardingUserRoleEntityFromJson should convert a JSON string to a OnBoardingUserRoleEntity object', () {
      // Arrange
      const jsonString =
          '{"_id": "123", "type": "type", "title": "title", "description": "description", "imageUrl": "imageUrl", "updated_at": "updated_at", "created_at": "created_at", "__v": 1}';

      // Act
      final entity = onBoardingUserRoleEntityFromJson(jsonString);

      // Assert
      expect(entity.id, "123");
      expect(entity.type, "type");
      expect(entity.title, "title");
      expect(entity.description, "description");
      expect(entity.imageUrl, "imageUrl");
      expect(entity.updatedAt, "updated_at");
      expect(entity.createdAt, "created_at");
      expect(entity.v, 1);
    });

    test('onBoardingUserRoleEntityToJson should convert a OnBoardingUserRoleEntity object to a JSON string', () {
      // Arrange
      final entity = OnBoardingUserRoleEntity(
        id: "123",
        type: "type",
        title: "title",
        description: "description",
        imageUrl: "imageUrl",
        updatedAt: "updated_at",
        createdAt: "created_at",
        v: 1,
      );

      // Act
      final jsonString = onBoardingUserRoleEntityToJson(entity);
      final decoded = json.decode(jsonString);

      // Assert
      expect(decoded["_id"], "123");
      expect(decoded["type"], "type");
      expect(decoded["title"], "title");
      expect(decoded["description"], "description");
      expect(decoded["imageUrl"], "imageUrl");
      expect(decoded["updated_at"], "updated_at");
      expect(decoded["created_at"], "created_at");
      expect(decoded["__v"], 1);
    });
  });
}
