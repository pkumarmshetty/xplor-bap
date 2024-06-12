import 'dart:convert';

class StatusPostEntity {
  final String orderId;
  final String domain;
  final String deviceId;
  final String itemId;
  final String transactionId;

  StatusPostEntity(
      {required this.transactionId,
      required this.domain,
      required this.orderId,
      required this.itemId,
      required this.deviceId});

  String toJson() {
    return json.encode({
      'domain': domain,
      'order_id': orderId,
      'item_id': itemId,
      'transaction_id': transactionId,
      'deviceId': deviceId
    });
  }
}
