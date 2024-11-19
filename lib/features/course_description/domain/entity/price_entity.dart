class PriceEntity {
  final String currency;
  final String value;

  PriceEntity({
    required this.currency,
    required this.value,
  });

  factory PriceEntity.fromJson(Map<String, dynamic> json) {
    return PriceEntity(
      currency: json['currency'] ?? "",
      value: json['value'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'value': value,
    };
  }
}
