import '../../domain/entities/wallet_add_document_entity.dart';

class WalletAddDocumentModel extends WalletAddDocumentEntity {
  WalletAddDocumentModel({
    super.category,
    super.file,
    super.iconUrl,
    super.name,
    super.tags,
    super.type,
    super.walletId,
  });

  /// Creates a [WalletAddDocumentModel] object from a JSON map.
  factory WalletAddDocumentModel.fromJson(Map<String, dynamic> json) => WalletAddDocumentModel(
        walletId: json['walletId'],
        type: json['type'],
        category: json['category'],
        tags: List<String>.from(json['tags'] ?? []),
        name: json['name'],
        iconUrl: json['iconUrl'],
        file: json['file'],
      );

  /// Converts the [WalletAddDocumentModel] object to a JSON map.
  @override
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
