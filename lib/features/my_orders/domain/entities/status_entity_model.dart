import '../../../apply_course/domain/entities/get_response_entity/stop_entity.dart';
import 'my_orders_entity.dart';

class StatusEntityModel {
  final bool success;
  final String action;
  final String certificateUrl;
  Fulfillment? fulfillment;
  final List<StopsEntity>? stops;

  StatusEntityModel(
      {required this.success,
      required this.action,
      required this.fulfillment,
      required this.certificateUrl,
      required this.stops});

  factory StatusEntityModel.fromJson(Map<String, dynamic> json) {
    return StatusEntityModel(
      success: json['success'] ?? false,
      action: json['action'] ?? "",
      certificateUrl: json['certificate_url'] ?? "",
      fulfillment: json['fulfillment'] == null ? null : Fulfillment.fromJson(json['fulfillment']),
      stops: json['stops'] == null ? [] : List<StopsEntity>.from(json['stops'].map((i) => StopsEntity.fromJson(i))),
    );
  }
}
