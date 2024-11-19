class DocumentData {
  final String name;
  final bool isSelected;
  final bool isVerified;
  final List<String> tags;

  DocumentData({required this.name, required this.isSelected, required this.isVerified, required this.tags});

  DocumentData copyWith({
    String? name,
    bool? isSelected,
    bool? isVerified,
    List<String>? tags,
  }) {
    return DocumentData(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      isVerified: isVerified ?? this.isVerified,
      tags: tags ?? this.tags,
    );
  }
}
