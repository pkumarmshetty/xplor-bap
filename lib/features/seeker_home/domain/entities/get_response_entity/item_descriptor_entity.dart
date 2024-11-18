part of 'services_items.dart';

class ItemDescriptor {
  final String itemId;
  final String name;
  final String shortDesc;
  final String longDesc;
  final List<String> images;

  ItemDescriptor({
    required this.itemId,
    required this.name,
    required this.shortDesc,
    required this.longDesc,
    required this.images,
  });

  factory ItemDescriptor.fromJson(Map<String, dynamic> json) {
    return ItemDescriptor(
      itemId: json['item_id'] ?? "",
      name: json['name'] ?? "",
      shortDesc: json['short_desc'] ?? "",
      longDesc: json['long_desc'] ?? "",
      images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    );
  }
}
