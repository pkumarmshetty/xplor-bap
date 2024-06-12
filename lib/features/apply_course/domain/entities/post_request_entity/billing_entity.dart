part of 'init_post_entity.dart';

class BillingAddress {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  BillingAddress(
      {required this.street, required this.city, required this.state, required this.postalCode, required this.country});

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
    };
  }
}
