class UpdateConsentEntity {
  String remarks;
  String sharedWithEntity;
  ConsentRestrictions restrictions;

  UpdateConsentEntity({
    required this.remarks,
    required this.sharedWithEntity,
    required this.restrictions,
  });

  Map<String, dynamic> toJson() {
    return {
      'remarks': remarks,
      'sharedWithEntity': sharedWithEntity,
      'restrictions': restrictions.toJson(),
    };
  }
}

class ConsentRestrictions {
  int expiresIn;
  bool viewOnce;

  ConsentRestrictions({
    required this.expiresIn,
    required this.viewOnce,
  });

  Map<String, dynamic> toJson() {
    return {
      'expiresIn': expiresIn,
      'viewOnce': viewOnce,
    };
  }
}
