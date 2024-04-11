class EAuthProviderEntity {
  final String code;
  final String iconLink;
  final String title;
  final String subTitle;
  final String redirectUrl;

  EAuthProviderEntity({
    required this.code,
    required this.iconLink,
    required this.title,
    required this.subTitle,
    required this.redirectUrl,
  });

  factory EAuthProviderEntity.fromJson(Map<String, dynamic> json) {
    return EAuthProviderEntity(
      code: json['code'],
      iconLink: json['iconLink'],
      title: json['title'],
      subTitle: json['subTitle'],
      redirectUrl: json['redirectUrl'],
    );
  }
}