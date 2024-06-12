class CategoryEntity {
  String? id;
  String? category;
  String? value;
  bool? isSelected;

  CategoryEntity({
    this.id,
    this.category,
    this.value,
    this.isSelected,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['_id'] ?? "",
      category: json['title'] ?? "",
      value: json['value'] ?? "",
      isSelected: json['isSelected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = category;
    data['value'] = value;
    data['isSelected'] = isSelected;

    return data;
  }

  CategoryEntity copyWith({
    String? id,
    String? category,
    String? value,
    bool? isSelected,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      category: category ?? this.category,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
