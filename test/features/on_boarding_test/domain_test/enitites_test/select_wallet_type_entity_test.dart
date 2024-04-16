import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/domain/entities/select_wallet_type_entity.dart';

void main() {
  group('WalletSelectionEntity JSON Deserialization', () {
    test('fromJson should convert a JSON map to a WalletSelectionEntity object', () {
      // Arrange
      final json = {
        "icon": "icon_path",
        "title": "Selection Title",
        "message": "Selection Message",
      };

      // Act
      final entity = WalletSelectionEntity.fromJson(json);

      // Assert
      expect(entity.icon, "icon_path");
      expect(entity.title, "Selection Title");
      expect(entity.message, "Selection Message");
    });
  });
}
