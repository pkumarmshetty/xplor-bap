import 'dart:convert';

class ConfirmPostEntity {
  final String itemId;
  final String domain;
  final String deviceId;
  final String providerId;
  final String transactionId;

  ConfirmPostEntity(
      {required this.transactionId,
      required this.domain,
      required this.deviceId,
      required this.itemId,
      required this.providerId});

  String toJson() {
    return json.encode({
      'deviceId': deviceId,
      'item_id': itemId,
      'domain': domain,
      'provider_id': providerId,
      'transaction_id': transactionId,
    });
  }
}
