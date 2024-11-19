import '../../domain/entities/wallet_file_data_entity.dart';

class FileDataModel extends FileDataEntity {
  FileDataModel({
    super.walletId,
    super.fileType,
    super.fileKey,
    super.storedUrl,
    super.id,
    super.createdAt,
    super.updatedAt,
    super.v,
  });

  factory FileDataModel.fromJson(Map<String, dynamic> json) => FileDataModel(
        walletId: json['walletId'],
        fileType: json['fileType'],
        fileKey: json['fileKey'],
        storedUrl: json['storedUrl'],
        id: json['_id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        v: json['__v'],
      );

  @override
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
