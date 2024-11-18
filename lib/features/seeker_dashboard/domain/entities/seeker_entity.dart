class SeekerEntity {
  String? title;
  String? subTitle;
  String? icon;

  SeekerEntity({
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  factory SeekerEntity.fromJson(Map<String, dynamic> json) {
    return SeekerEntity(
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
