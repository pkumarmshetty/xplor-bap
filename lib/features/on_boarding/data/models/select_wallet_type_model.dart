import 'package:xplor/features/on_boarding/domain/entities/select_wallet_type_entity.dart';

class WalletSelectionModel extends WalletSelectionEntity {
  WalletSelectionModel({
    required super.icon,
    required super.title,
    required super.message,
  });

  /// Creates a [WalletSelectModel] object from a JSON map.
  factory WalletSelectionModel.fromJson(Map<String, dynamic> json) =>
      WalletSelectionModel(
        icon: json["icon"],
        title: json["title"],
        message: json["message"],
      );
}
