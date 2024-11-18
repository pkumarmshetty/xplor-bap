import 'dart:convert';

/// Converts a JSON string to a [AddDocumentToWalletEntity] object.
AddDocumentToWalletEntity fromJson(String str) => AddDocumentToWalletEntity.fromJson(json.decode(str));

/// Converts a [AddDocumentToWalletEntity] object to a JSON string.
String toJson(AddDocumentToWalletEntity data) => json.encode(data.toJson());

class AddDocumentToWalletEntity {
  String? walletId;
  String? category;
  String? name;
  String? fileUrl;
  final List<String> tags;

  AddDocumentToWalletEntity({
    this.walletId,
    this.category,
    this.name,
    this.fileUrl,
    required this.tags,
  });

  /// Creates a [AddDocumentToWalletEntity] object from a JSON map.
  factory AddDocumentToWalletEntity.fromJson(Map<String, dynamic> json) => AddDocumentToWalletEntity(
        walletId: json["walletId"],
        category: json["category"],
        name: json["name"],
        fileUrl: json["fileUrl"],
        tags: List<String>.from(json['tags'] ?? []),
      );

  /// Converts the [AddDocumentToWalletEntity] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'category': category,
      'name': name,
      'fileUrl': fileUrl,
      'tags': tags,
    };
  }
}
