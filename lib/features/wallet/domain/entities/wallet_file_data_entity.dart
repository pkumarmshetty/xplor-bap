import 'dart:convert';

/// Converts a JSON string to a [FileDataEntity] object.
FileDataEntity fileDataEntityFromJson(String str) => FileDataEntity.fromJson(json.decode(str));

/// Converts a [FileDataEntity] object to a JSON string.
String fileDataEntityToJson(FileDataEntity data) => json.encode(data.toJson());

class FileDataEntity {
  String? walletId;
  String? fileType;
  String? fileKey;
  String? storedUrl;
  String? id;
  String? createdAt;
  String? updatedAt;
  int? v;

  FileDataEntity({
    this.walletId,
    this.fileType,
    this.fileKey,
    this.storedUrl,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FileDataEntity.fromJson(Map<String, dynamic> json) => FileDataEntity(
        walletId: json['walletId'],
        fileType: json['fileType'],
        fileKey: json['fileKey'],
        storedUrl: json['storedUrl'],
        id: json['_id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        'walletId': walletId,
        'fileType': fileType,
        'fileKey': fileKey,
        'storedUrl': storedUrl,
        '_id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        '__v': v,
      };
}
