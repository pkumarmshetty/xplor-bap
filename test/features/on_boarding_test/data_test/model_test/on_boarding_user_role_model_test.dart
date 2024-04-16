import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/on_boarding_user_role_model.dart';

void main() {
  group('OnBoardingUserRoleModel JSON Serialization', () {
    test('fromJson should convert a JSON map to a OnBoardingUserRoleModel object', () {
      // Arrange
      final jsonMap = {
        "_id": "123",
        "type": "type",
        "title": "title",
        "description": "description",
        "imageUrl": "imageUrl",
        "updated_at": "2022-04-01T12:00:00Z",
        "created_at": "2022-04-01T12:00:00Z",
        "__v": 1,
      };

      // Act
      final model = OnBoardingUserRoleModel.fromJson(jsonMap);

      // Assert
      expect(model.id, "123");
      expect(model.type, "type");
      expect(model.title, "title");
      expect(model.description, "description");
      expect(model.imageUrl, "imageUrl");
      expect(model.updatedAt, "2022-04-01T12:00:00Z");
      expect(model.createdAt, "2022-04-01T12:00:00Z");
      expect(model.v, 1);
    });

    test('toJson should convert a OnBoardingUserRoleModel object to a JSON map', () {
      // Arrange
      final model = OnBoardingUserRoleModel(
        id: "123",
        type: "type",
        title: "title",
        description: "description",
        imageUrl: "imageUrl",
        updatedAt: "2022-04-01T12:00:00Z",
        createdAt: "2022-04-01T12:00:00Z",
        v: 1,
      );

      // Act
      final jsonMap = model.toJson();

      // Assert
      expect(jsonMap["_id"], "123");
      expect(jsonMap["type"], "type");
      expect(jsonMap["title"], "title");
      expect(jsonMap["description"], "description");
      expect(jsonMap["imageUrl"], "imageUrl");
      expect(jsonMap["updated_at"], "2022-04-01T12:00:00Z");
      expect(jsonMap["created_at"], "2022-04-01T12:00:00Z");
      expect(jsonMap["__v"], 1);
    });
  });
}
