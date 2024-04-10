import 'dart:convert';

class OnBoardingUserRoleEntity {
  String? id;
  String? type;
  String? title;
  String? description;
  String? imageUrl;
  String? updatedAt;
  String? createdAt;
  int? v;

  OnBoardingUserRoleEntity({
    this.id,
    this.type,
    this.title,
    this.description,
    this.imageUrl,
    this.updatedAt,
    this.createdAt,
    this.v,
  });

  /// Creates a [OnBoardingUserRoleEntity] object from a JSON map.
  factory OnBoardingUserRoleEntity.fromJson(Map<String, dynamic> json) =>
      OnBoardingUserRoleEntity(
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

/// Converts a JSON string to a [OnBoardingUserRoleEntity] object.
OnBoardingUserRoleEntity onBoardingUserRoleEntityFromJson(String str) =>
    OnBoardingUserRoleEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingUserRoleEntity] object to a JSON string.
String onBoardingUserRoleEntityToJson(OnBoardingUserRoleEntity data) =>
    json.encode(data.toJson());
