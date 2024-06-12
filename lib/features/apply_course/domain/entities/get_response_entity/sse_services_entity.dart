import 'package:xplor/features/apply_course/domain/entities/get_response_entity/stop_entity.dart';

import 'price_entity.dart';

part 'breakup_entity.dart';

part 'payment_entity.dart';

class SseServicesEntity {
  final bool success;
  final String transactionId;
  final String itemId;
  final String domain;
  final String action;
  final String orderId;
  final String status;
  final String formUrl;
  final Quote? quote;
  final List<PaymentEntity>? payments;
  final List<StopsEntity>? stops;

  SseServicesEntity({
    required this.transactionId,
    required this.success,
    required this.itemId,
    required this.domain,
    required this.action,
    required this.quote,
    required this.formUrl,
    required this.payments,
    required this.stops,
    required this.status,
    required this.orderId,
  });

  factory SseServicesEntity.fromJson(Map<String, dynamic> json) {
    return SseServicesEntity(
      transactionId: json['transaction_id'] ?? "",
      success: json['success'] ?? false,
      itemId: json['item_id'] ?? "",
      domain: json['domain'] ?? "",
      action: json['action'] ?? "",

      ///Info getting this on "action": "on_confirm" and on_status
      orderId: json['order_id'] ?? "",
      status: json['status'] ?? "",

      ///Info getting this on "action": "on_init"
      formUrl: json['form_url'] ?? "",

      ///Info getting this on "action": "on_select",
      quote: json['quote'] == null ? null : Quote.fromJson(json['quote']),

      ///Info getting this on "action": "on_init" and confirm
      payments: json['payments'] == null
          ? []
          : List<PaymentEntity>.from(json['payments'].map((i) => PaymentEntity.fromJson(i))),

      ///Info getting this on "action": "on_confirm"
      stops: json['stops'] == null ? [] : List<StopsEntity>.from(json['stops'].map((i) => StopsEntity.fromJson(i))),
    );
  }
}

class Quote {
  final PriceEntity? price;
  final List<BreakupEntity> breakup;

  Quote({
    required this.price,
    required this.breakup,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      price: json['price'] == null ? null : PriceEntity.fromJson(json['price']),
      breakup: json["breakup"] == null
          ? []
          : List<BreakupEntity>.from(json["breakup"]!.map((x) => BreakupEntity.fromJson(x))),
    );
  }
}
