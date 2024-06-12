part of 'services_items.dart';

class ProviderInfoEntity {
  final String id;
  final String name;
  final String shortDesc;
  final String longDesc;
  final List<String> images;

  ProviderInfoEntity({
    required this.id,
    required this.name,
    required this.shortDesc,
    required this.longDesc,
    required this.images,
  });

  factory ProviderInfoEntity.fromJson(Map<String, dynamic> json) {
    return ProviderInfoEntity(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      shortDesc: json['short_desc'] ?? "",
      longDesc: json['long_desc'] ?? "",
      images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    );
  }
}
