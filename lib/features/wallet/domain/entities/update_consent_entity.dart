class UpdateConsentEntity {
  String remarks;
  ConsentRestrictions restrictions;

  UpdateConsentEntity({
    required this.remarks,
    required this.restrictions,
  });

  Map<String, dynamic> toJson() {
    return {
      'remarks': remarks,
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
