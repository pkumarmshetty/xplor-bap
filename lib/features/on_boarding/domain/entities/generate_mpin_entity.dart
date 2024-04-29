/// success : true
/// message : "Created"
/// data : {"_id":"user_8cfd8f61-a87e-4f31-97aa-e31143f400fc","phoneNumber":"+917870600457","verified":true,"kycStatus":false,"wallet":null,"updated_at":"2024-04-15T08:19:21.901Z","created_at":"2024-04-15T08:19:21.901Z","__v":0,"mPin":"$argon2id$v=19$m=65536,t=3,p=4$gfhQypBIYu5ms9JUGtCfSA$33a+rs4WpkeK05eB5Esk3gPgjr9tb63HrH1bLUL0zSI"}
library;

class GenerateMpinEntity {
  GenerateMpinEntity({
    bool? success,
    String? message,
    MpinData? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  GenerateMpinEntity.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? MpinData.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  MpinData? _data;
  GenerateMpinEntity copyWith({
    bool? success,
    String? message,
    MpinData? data,
  }) =>
      GenerateMpinEntity(
        success: success ?? _success,
        message: message ?? _message,
        data: data ?? _data,
      );
  bool? get success => _success;
  String? get message => _message;
  MpinData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// _id : "user_8cfd8f61-a87e-4f31-97aa-e31143f400fc"
/// phoneNumber : "+917870600457"
/// verified : true
/// kycStatus : false
/// wallet : null
/// updated_at : "2024-04-15T08:19:21.901Z"
/// created_at : "2024-04-15T08:19:21.901Z"
/// __v : 0
/// mPin : "$argon2id$v=19$m=65536,t=3,p=4$gfhQypBIYu5ms9JUGtCfSA$33a+rs4WpkeK05eB5Esk3gPgjr9tb63HrH1bLUL0zSI"

class MpinData {
  MpinData({
    String? id,
    String? phoneNumber,
    bool? verified,
    bool? kycStatus,
    dynamic wallet,
    String? updatedAt,
    String? createdAt,
    num? v,
    String? mPin,
  }) {
    _id = id;
    _phoneNumber = phoneNumber;
    _verified = verified;
    _kycStatus = kycStatus;
    _wallet = wallet;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _v = v;
    _mPin = mPin;
  }

  MpinData.fromJson(dynamic json) {
    _id = json['_id'];
    _phoneNumber = json['phoneNumber'];
    _verified = json['verified'];
    _kycStatus = json['kycStatus'];
    _wallet = json['wallet'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _v = json['__v'];
    _mPin = json['mPin'];
  }
  String? _id;
  String? _phoneNumber;
  bool? _verified;
  bool? _kycStatus;
  dynamic _wallet;
  String? _updatedAt;
  String? _createdAt;
  num? _v;
  String? _mPin;
  MpinData copyWith({
    String? id,
    String? phoneNumber,
    bool? verified,
    bool? kycStatus,
    dynamic wallet,
    String? updatedAt,
    String? createdAt,
    num? v,
    String? mPin,
  }) =>
      MpinData(
        id: id ?? _id,
        phoneNumber: phoneNumber ?? _phoneNumber,
        verified: verified ?? _verified,
        kycStatus: kycStatus ?? _kycStatus,
        wallet: wallet ?? _wallet,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        v: v ?? _v,
        mPin: mPin ?? _mPin,
      );
  String? get id => _id;
  String? get phoneNumber => _phoneNumber;
  bool? get verified => _verified;
  bool? get kycStatus => _kycStatus;
  dynamic get wallet => _wallet;
  String? get updatedAt => _updatedAt;
  String? get createdAt => _createdAt;
  num? get v => _v;
  String? get mPin => _mPin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['phoneNumber'] = _phoneNumber;
    map['verified'] = _verified;
    map['kycStatus'] = _kycStatus;
    map['wallet'] = _wallet;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['__v'] = _v;
    map['mPin'] = _mPin;
    return map;
  }
}
