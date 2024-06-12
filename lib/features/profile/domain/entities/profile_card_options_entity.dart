class ProfileCardOptionsEntity {
  String? title;
  String? subTitle;
  String? icon;

  ProfileCardOptionsEntity({
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  factory ProfileCardOptionsEntity.fromJson(Map<String, dynamic> json) {
    return ProfileCardOptionsEntity(
      title: json['title'] ?? "",
      subTitle: json['subTitle'] ?? "",
      icon: json['icon'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['icon'] = icon;
    return data;
  }
}
