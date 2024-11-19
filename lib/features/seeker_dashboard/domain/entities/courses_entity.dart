class CoursesEntity {
  String? image;
  String? title;
  String? subTitle;
  String? price;

  CoursesEntity({
    required this.image,
    required this.title,
    required this.subTitle,
    required this.price,
  });

  factory CoursesEntity.fromJson(Map<String, dynamic> json) {
    return CoursesEntity(
      image: json['image'] ?? "",
      title: json['title'] ?? "",
      subTitle: json['subTitle'] ?? "",
      price: json['price'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['price'] = price;
    return data;
  }
}
