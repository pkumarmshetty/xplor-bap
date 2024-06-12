class SelectedDomainsEntity {
  String deviceId;
  List<String> domains;
  String? languageCode;

  SelectedDomainsEntity({
    required this.deviceId,
    required this.domains,
    this.languageCode,
  });

  Map<String, dynamic> toMap() {
    return {'deviceId': deviceId, 'domains': domains, 'languageCode': languageCode};
  }
}
