class KycSseResponse {
  final bool kycStatus;
  final String message;

  const KycSseResponse({
    required this.kycStatus,
    required this.message,
  });

  factory KycSseResponse.fromJson(Map<String, dynamic> map) {
    return KycSseResponse(
      kycStatus: map['kycStatus'] ?? false,
      message: map['message'] ?? "",
    );
  }
}
