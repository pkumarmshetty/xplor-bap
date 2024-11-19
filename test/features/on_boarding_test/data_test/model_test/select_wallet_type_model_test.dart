import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/select_wallet_type_model.dart';

void main() {
  group('WalletSelectionModel JSON Deserialization', () {
    test('fromJson should convert a JSON map to a WalletSelectionModel object', () {
      // Arrange
      final jsonMap = {
        "icon": "icon_url",
        "title": "Wallet Title",
        "message": "Wallet Message",
      };

      // Act
      final model = WalletSelectionModel.fromJson(jsonMap);

      // Assert
      expect(model.icon, "icon_url");
      expect(model.title, "Wallet Title");
      expect(model.message, "Wallet Message");
    });
  });
}
