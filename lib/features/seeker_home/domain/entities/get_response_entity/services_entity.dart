import 'services_items.dart';

class ServicesSearchEntity {
  final int? data;
  final int? totalCount;
  final String? transactionId;
  final int? skip;
  final String? limit;
  final List<SearchItemEntity>? items;

  ServicesSearchEntity({
    this.data,
    this.totalCount,
    this.transactionId,
    this.skip,
    this.limit,
    this.items,
  });

  factory ServicesSearchEntity.fromJson(Map<String, dynamic> json) {
    return ServicesSearchEntity(
      data: json['data'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      transactionId: json['transaction_id'] ?? "",
      skip: json['skip'] ?? 0,
      limit: json['limit'] ?? 0,
      items: json["items"] == null
          ? []
          : List<SearchItemEntity>.from(json["items"]!.map((x) => SearchItemEntity.fromJson(x))),
    );
  }
}
