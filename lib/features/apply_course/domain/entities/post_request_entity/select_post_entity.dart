import 'dart:convert';

class SelectPostEntity {
  final String itemId;
  final String domain;
  final String deviceId;
  final String providerId;
  final String transactionId;

  SelectPostEntity({
    required this.itemId,
    required this.providerId,
    required this.deviceId,
    required this.domain,
    required this.transactionId,
  });

  String toJson() {
    return json.encode({
      'item_id': itemId,
      'deviceId': deviceId,
      'domain': domain,
      'provider_id': providerId,
      'transaction_id': transactionId,
    });
  }
}
