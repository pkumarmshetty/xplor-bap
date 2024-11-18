import 'dart:convert';
import 'dart:io';

/// Converts a JSON string to a [WalletAddDocumentEntity] object.
WalletAddDocumentEntity addDocumentEntityFromJson(String str) => WalletAddDocumentEntity.fromJson(json.decode(str));

/// Converts a [WalletAddDocumentEntity] object to a JSON string.
String addDocumentEntityToJson(WalletAddDocumentEntity data) => json.encode(data.toJson());

class WalletAddDocumentEntity {
  String? walletId;
  String? type;
  String? category;
  List<String>? tags;
  String? name;
  String? iconUrl;
  File? file;

  WalletAddDocumentEntity({
    this.walletId,
    this.type,
    this.category,
    this.tags,
    this.name,
    this.iconUrl,
    this.file,
  });

  factory WalletAddDocumentEntity.fromJson(Map<String, dynamic> json) => WalletAddDocumentEntity(
        walletId: json['walletId'],
        type: json['type'],
        category: json['category'],
        tags: List<String>.from(json['tags'] ?? []),
        name: json['name'],
        iconUrl: json['iconUrl'],
        file: json['file'],
      );

  Map<String, dynamic> toJson() => {
        'walletId': walletId,
        'type': type,
        'category': category,
        'tags': tags,
        'name': name,
        'iconUrl': iconUrl,
        'file': file,
      };
}
