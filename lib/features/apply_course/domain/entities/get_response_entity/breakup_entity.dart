part of 'sse_services_entity.dart';

class BreakupEntity {
  final String title;
  final PriceEntity? price;

  BreakupEntity({
    required this.title,
    required this.price,
  });

  factory BreakupEntity.fromJson(Map<String, dynamic> json) {
    return BreakupEntity(
      title: json['title'] ?? "",
      price: json['price'] == null ? null : PriceEntity.fromJson(json['price']),
    );
  }
}
