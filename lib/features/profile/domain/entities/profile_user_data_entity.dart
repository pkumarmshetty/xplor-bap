class ProfileUserDataEntity {
  String? id;
  String? phoneNumber;
  bool? verified;
  bool? kycStatus;
  String? wallet;
  String? mPin;
  String? updatedAt;
  String? createdAt;
  int? v;
  Role role;
  Kyc kyc;

  ProfileUserDataEntity({
    required this.id,
    required this.phoneNumber,
    required this.verified,
    required this.kycStatus,
    required this.wallet,
    required this.mPin,
    required this.updatedAt,
    required this.createdAt,
    required this.v,
    required this.role,
    required this.kyc,
  });

  factory ProfileUserDataEntity.fromJson(Map<String, dynamic> json) {
    return ProfileUserDataEntity(
      id: json['_id'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      verified: json['verified'] ?? "",
      kycStatus: json['kycStatus'] ?? "",
      wallet: json['wallet'] ?? "",
      mPin: json['mPin'] ?? "",
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      v: json['__v'],
      role: Role.fromJson(json['role']),
      kyc: Kyc.fromJson(json['kyc']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['verified'] = verified;
    data['kycStatus'] = kycStatus;
    data['wallet'] = wallet;
    data['mPin'] = mPin;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['__v'] = v;
    data['role'] = role.toJson();
    data['kyc'] = kyc.toJson();
    return data;
  }
}

class Role {
  String id;
  String type;
  String title;
  String description;
  String imageUrl;
  String createdAt;
  String updatedAt;
  int v;

  Role({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['_id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = v;
    return data;
  }
}

class Kyc {
  String? lastName;
  String? firstName;
  String? address;
  String? email;
  String? gender;
  String? dob;
  Provider provider;
  String? id;
  String? updatedAt;
  String? createdAt;

  Kyc({
    required this.lastName,
    required this.firstName,
    required this.address,
    required this.email,
    required this.gender,
    required this.dob,
    required this.provider,
    required this.id,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) {
    return Kyc(
      lastName: json['lastName'] ?? "NA",
      firstName: json['firstName'] ?? "NA",
      address: json['address'] ?? "NA",
      email: json['email'] ?? "NA",
      gender: json['gender'] ?? "NA",
      dob: json['dob'] ?? "",
      provider: Provider.fromJson(json['provider']),
      id: json['_id'] ?? "NA",
      updatedAt: json['updated_at'] ?? "NA",
      createdAt: json['created_at'] ?? "NA",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lastName'] = lastName;
    data['firstName'] = firstName;
    data['address'] = address;
    data['email'] = email;
    data['gender'] = gender;
    data['provider'] = provider.toJson();
    data['_id'] = id;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}

class Provider {
  String id;
  String name;

  Provider({
    required this.id,
    required this.name,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
