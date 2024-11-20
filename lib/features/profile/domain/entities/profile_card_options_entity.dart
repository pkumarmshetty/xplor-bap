import 'package:xplor/config/routes/path_routing.dart';

/// Entity class for the profile card options.
class ProfileCardOptionsEntity {
  String? title;
  String? subTitle;
  String? icon;
  String route;

  ProfileCardOptionsEntity({
    required this.title,
    required this.subTitle,
    required this.icon,
    this.route = Routes.editProfile,
  });

  factory ProfileCardOptionsEntity.fromJson(Map<String, dynamic> json) {
    return ProfileCardOptionsEntity(
      title: json['title'] ?? "",
      subTitle: json['subTitle'] ?? "",
      icon: json['icon'] ?? "",
      route: json["route"] ?? Routes.editProfile
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['icon'] = icon;
    data['route'] = route;
    return data;
  }
}
