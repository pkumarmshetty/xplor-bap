class SharedVcDataEntity {
  final String id;
  final String vcId;
  final String status;
  final String restrictedUrl;
  final String raisedByWallet;
  final String vcOwnerWallet;
  final String remarks;
  final DocVcSharedDetails vcShareDetails;
  final String createdAt;
  final String updatedAt;
  final int v;
  final FileDetails fileDetails;
  final VcDetails vcDetails;

  SharedVcDataEntity({
    required this.id,
    required this.vcId,
    required this.status,
    required this.restrictedUrl,
    required this.raisedByWallet,
    required this.vcOwnerWallet,
    required this.remarks,
    required this.vcShareDetails,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.fileDetails,
    required this.vcDetails,
  });

  factory SharedVcDataEntity.fromJson(Map<String, dynamic> json) {
    return SharedVcDataEntity(
      id: json['_id'],
      vcId: json['vcId'],
      status: json['status'],
      restrictedUrl: json['restrictedUrl'],
      raisedByWallet: json['raisedByWallet'],
      vcOwnerWallet: json['vcOwnerWallet'],
      remarks: json['remarks'],
      vcShareDetails: DocVcSharedDetails.fromJson(json['vcShareDetails']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      fileDetails: FileDetails.fromJson(json['fileDetails']),
      vcDetails: VcDetails.fromJson(json['vcDetails']),
    );
  }
}

class DocVcSharedDetails {
  final String certificateType;
  final Restrictions restrictions;

  DocVcSharedDetails({
    required this.certificateType,
    required this.restrictions,
  });

  factory DocVcSharedDetails.fromJson(Map<String, dynamic> json) {
    return DocVcSharedDetails(
      certificateType: json['certificateType'],
      restrictions: Restrictions.fromJson(json['restrictions']),
    );
  }
}

class Restrictions {
  final int expiresIn;
  final bool viewOnce;

  Restrictions({
    required this.expiresIn,
    required this.viewOnce,
  });

  factory Restrictions.fromJson(Map<String, dynamic> json) {
    return Restrictions(
      expiresIn: json['expiresIn'],
      viewOnce: json['viewOnce'],
    );
  }
}

class FileDetails {
  final String id;
  final String walletId;
  final String fileType;
  final String createdAt;
  final String updatedAt;
  final int v;

  FileDetails({
    required this.id,
    required this.walletId,
    required this.fileType,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory FileDetails.fromJson(Map<String, dynamic> json) {
    return FileDetails(
      id: json['_id'],
      walletId: json['walletId'],
      fileType: json['fileType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}

class VcDetails {
  final String id;
  final String did;
  final String fileId;
  final String walletId;
  final String type;
  final String category;
  final List<String> tags;
  final String name;
  final String? iconUrl;
  final String? templateId;
  final String restrictedUrl;
  final String createdAt;
  final String updatedAt;
  final int v;

  VcDetails({
    required this.id,
    required this.did,
    required this.fileId,
    required this.walletId,
    required this.type,
    required this.category,
    required this.tags,
    required this.name,
    required this.iconUrl,
    required this.templateId,
    required this.restrictedUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory VcDetails.fromJson(Map<String, dynamic> json) {
    return VcDetails(
      id: json['_id'],
      did: json['did'],
      fileId: json['fileId'],
      walletId: json['walletId'],
      type: json['type'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
      name: json['name'],
      iconUrl: json['iconUrl'],
      templateId: json['templateId'],
      restrictedUrl: json['restrictedUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
