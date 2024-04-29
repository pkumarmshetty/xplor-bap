class PreviousConsentEntity {
  String id;
  String vcId;
  String status;
  String restrictedUrl;
  String raisedByWallet;
  String vcOwnerWallet;
  String remarks;
  VcShareDetails vcShareDetails;
  String createdAt;
  String updatedAt;
  int v;

  PreviousConsentEntity({
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
  });

  factory PreviousConsentEntity.fromJson(Map<String, dynamic> json) {
    return PreviousConsentEntity(
      id: json['_id'],
      vcId: json['vcId'],
      status: json['status'],
      restrictedUrl: json['restrictedUrl'],
      raisedByWallet: json['raisedByWallet'],
      vcOwnerWallet: json['vcOwnerWallet'],
      remarks: json['remarks'],
      vcShareDetails: VcShareDetails.fromJson(json['vcShareDetails']),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vcId': vcId,
      'status': status,
      'restrictedUrl': restrictedUrl,
      'raisedByWallet': raisedByWallet,
      'vcOwnerWallet': vcOwnerWallet,
      'remarks': remarks,
      'vcShareDetails': vcShareDetails.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}

class VcShareDetails {
  String certificateType;
  Restrictions restrictions;

  VcShareDetails({
    required this.certificateType,
    required this.restrictions,
  });

  factory VcShareDetails.fromJson(Map<String, dynamic> json) {
    return VcShareDetails(
      certificateType: json['certificateType'],
      restrictions: Restrictions.fromJson(json['restrictions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificateType': certificateType,
      'restrictions': restrictions.toJson(),
    };
  }
}

class Restrictions {
  int expiresIn;
  bool viewOnce;

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

  Map<String, dynamic> toJson() {
    return {
      'expiresIn': expiresIn,
      'viewOnce': viewOnce,
    };
  }
}
