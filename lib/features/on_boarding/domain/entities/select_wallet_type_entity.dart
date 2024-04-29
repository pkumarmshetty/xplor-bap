class WalletSelectionEntity {
  final String icon;

  /// Icon image path
  final String title;

  /// Title of the selection entity
  final String message;

  /// Message associated with the selection entity

  WalletSelectionEntity({required this.icon, required this.title, required this.message});

  factory WalletSelectionEntity.fromJson(Map<String, dynamic> json) => WalletSelectionEntity(
        icon: json["icon"],
        title: json["title"],
        message: json["message"],
      );
}
