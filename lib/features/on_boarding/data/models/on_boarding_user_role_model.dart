import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';

class OnBoardingUserRoleModel extends OnBoardingUserRoleEntity {
  OnBoardingUserRoleModel({
    super.id,
    super.type,
    super.title,
    super.description,
    super.imageUrl,
    super.updatedAt,
    super.createdAt,
    super.v,
  });

  /// Creates a [OnBoardingUserRoleEntity] object from a JSON map.
  factory OnBoardingUserRoleModel.fromJson(Map<String, dynamic> json) => OnBoardingUserRoleModel(
        id: json["_id"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        updatedAt: json["updated_at"],
        createdAt: json["created_at"],
        v: json["__v"],
      );

  /// Converts the [OnBoardingUserRoleEntity] object to a JSON map.
  @override
  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "updated_at": updatedAt,
        "created_at": createdAt,
        "__v": v,
      };
}
