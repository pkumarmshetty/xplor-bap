import 'my_orders_entity.dart';

class StatusEntityModel {
  final bool success;
  final String action;
  final String certificateUrl;
  Fulfillment? fulfillment;

  StatusEntityModel(
      {required this.success, required this.action, required this.fulfillment, required this.certificateUrl});

  factory StatusEntityModel.fromJson(Map<String, dynamic> json) {
    return StatusEntityModel(
      success: json['success'] ?? false,
      action: json['action'] ?? "",
      certificateUrl: json['certificate_url'] ?? "",
      fulfillment: json['fulfillment'] == null ? null : Fulfillment.fromJson(json['fulfillment']),
    );
  }
}
