part of 'sse_services_entity.dart';

class PaymentEntity {
  final PaymentParamsEntity params;
  final String type;
  final String status;
  final String collectedBy;

  PaymentEntity({required this.params, required this.status, required this.collectedBy, required this.type});

  factory PaymentEntity.fromJson(Map<String, dynamic> json) {
    return PaymentEntity(
      params: PaymentParamsEntity.fromJson(
        json['params'],
      ),

      /// Info getting this on "action": "on_confirm"
      type: json['type'] ?? "",
      status: json['status'] ?? "",
      collectedBy: json['collected_by'] ?? "",
    );
  }
}

class PaymentParamsEntity {
  final String bankCode;
  final String bankAccountNumber;
  final String bankAccountName;
  final String amount;
  final String currency;

  PaymentParamsEntity({
    required this.bankCode,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.amount,
    required this.currency,
  });

  factory PaymentParamsEntity.fromJson(Map<String, dynamic> json) {
    return PaymentParamsEntity(
      ///Info getting this on "action": "on_init"
      bankCode: json['bank_code'] ?? "",
      bankAccountNumber: json['bank_account_number'] ?? "",
      bankAccountName: json['bank_account_name'] ?? "",

      /// Info getting this on "action": "on_confirm"
      amount: json['amount'] ?? "",
      currency: json['currency'] ?? "",
    );
  }
}
