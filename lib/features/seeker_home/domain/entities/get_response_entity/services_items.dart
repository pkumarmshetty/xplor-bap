import 'price_entity.dart';

part 'item_descriptor_entity.dart';

part 'provider_entity.dart';

class SearchItemEntity {
  final String id;
  final String itemId;
  final String transactionId;
  final String domain;
  final String rating;
  final bool enrolled;
  final ItemDescriptor descriptor;
  final PriceEntity price;
  final String providerId;
  final ProviderInfoEntity provider;

  SearchItemEntity({
    required this.id,
    required this.itemId,
    required this.transactionId,
    required this.domain,
    required this.rating,
    required this.descriptor,
    required this.price,
    required this.providerId,
    required this.provider,
    required this.enrolled,
  });

  factory SearchItemEntity.fromJson(Map<String, dynamic> json) {
    return SearchItemEntity(
      id: json['_id'] ?? "",
      transactionId: json['transaction_id'] ?? "",
      domain: json['domain'] ?? "",
      itemId: json['item_id'] ?? "",
      rating: json['rating'] ?? "0",
      enrolled: json['enrolled'] ?? false,
      descriptor: json['descriptor'] == null
          ? ItemDescriptor(itemId: "", name: "", shortDesc: "", longDesc: "", images: [])
          : ItemDescriptor.fromJson(json['descriptor']),
      price: json['price'] == null ? PriceEntity(currency: "INR", value: "NA") : PriceEntity.fromJson(json['price']),
      providerId: json['provider_id'] ?? "",
      provider: json['provider'] == null
          ? ProviderInfoEntity(id: "", name: "", shortDesc: "", longDesc: "", images: [])
          : ProviderInfoEntity.fromJson(json['provider']),
    );
  }
}
