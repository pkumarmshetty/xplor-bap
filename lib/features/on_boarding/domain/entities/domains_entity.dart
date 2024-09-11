class DomainData {
  final bool isSelected;
  final String id;
  final String title;
  final String description;
  final String domain;
  final String icon;

  const DomainData({
    required this.isSelected,
    required this.id,
    required this.title,
    required this.description,
    required this.domain,
    required this.icon,
  });

  DomainData copyWith({
    bool? isSelected,
    String? id,
    String? title,
    String? description,
    String? domain,
    String? icon,
  }) {
    return DomainData(
      isSelected: isSelected ?? this.isSelected,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      domain: domain ?? this.domain,
      icon: icon ?? this.icon,
    );
  }

  factory DomainData.fromJson(Map<String, dynamic> map) {
    return DomainData(
      isSelected: false,
      id: map['_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      domain: map['domain'] as String,
      icon: map['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['domain'] = domain;
    data['icon'] = icon;

    return data;
  }
}
