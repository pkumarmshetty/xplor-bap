/// mpinKey : "055a680342b70a9d58aeb757ca1bcea239c602478863bad5aca05592381ac486129a13f4389ed502e3f728b09ee5b0e4"
/// otp : "123456"
library;

class SendResetMpinOtpEntity {
  SendResetMpinOtpEntity({
    String? mpinKey,
    String? otp,
  }) {
    _mpinKey = mpinKey;
    _otp = otp;
  }

  SendResetMpinOtpEntity.fromJson(dynamic json) {
    _mpinKey = json['mpinKey'];
    _otp = json['otp'];
  }
  String? _mpinKey;
  String? _otp;
  SendResetMpinOtpEntity copyWith({
    String? mpinKey,
    String? otp,
  }) =>
      SendResetMpinOtpEntity(
        mpinKey: mpinKey ?? _mpinKey,
        otp: otp ?? _otp,
      );
  String? get mpinKey => _mpinKey;
  String? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mpinKey'] = _mpinKey;
    map['otp'] = _otp;
    return map;
  }
}
