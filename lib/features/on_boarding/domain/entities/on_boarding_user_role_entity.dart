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
  bool? isSelected;

  OnBoardingUserRoleEntity({
    this.id,
    this.type,
    this.title,
    this.description,
    this.imageUrl,
    this.updatedAt,
    this.createdAt,
    this.v,
    this.isSelected,
  });

  /// Creates a [OnBoardingUserRoleEntity] object from a JSON map.
  factory OnBoardingUserRoleEntity.fromJson(Map<String, dynamic> json) => OnBoardingUserRoleEntity(
        id: json["_id"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
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

  OnBoardingUserRoleEntity copyWith({
    String? id,
    String? type,
    String? title,
    String? description,
    String? imageUrl,
    String? updatedAt,
    String? createdAt,
    int? v,
    bool? isSelected,
  }) {
    return OnBoardingUserRoleEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      v: v ?? this.v,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Converts a JSON string to a [OnBoardingUserRoleEntity] object.
OnBoardingUserRoleEntity onBoardingUserRoleEntityFromJson(String str) =>
    OnBoardingUserRoleEntity.fromJson(json.decode(str));

/// Converts a [OnBoardingUserRoleEntity] object to a JSON string.
String onBoardingUserRoleEntityToJson(OnBoardingUserRoleEntity data) => json.encode(data.toJson());
