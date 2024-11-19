import 'dart:convert';

part 'billing_entity.dart';

class InitPostEntity {
  final BillingAddress billingAddress;

  final String transactionId;
  final String domain;
  final String itemId;
  final String deviceId;
  final String providerId;

  InitPostEntity({
    required this.billingAddress,
    required this.providerId,
    required this.itemId,
    required this.deviceId,
    required this.domain,
    required this.transactionId,
  });

  String toJson() {
    return json.encode({
      'transaction_id': transactionId,
      'billing_address': billingAddress.toJson(),
      'domain': domain,
      'deviceId': deviceId,
      'item_id': itemId,
      'provider_id': providerId,
    });
  }
}
