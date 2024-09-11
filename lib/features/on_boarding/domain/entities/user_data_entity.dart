import 'categories_entity.dart';
import 'domains_entity.dart';

class UserDataEntity {
  String? profileUrl;
  String? countryCode;
  String? id;
  String? phoneNumber;
  bool? verified;
  bool kycStatus;
  bool mPin;
  String? wallet;
  String? updatedAt;
  String? createdAt;
  int? v;
  Role? role;
  Kyc? kyc;
  Count count;
  List<CategoryEntity> categories;
  List<DomainData> domains;

  UserDataEntity({
    required this.profileUrl,
    required this.countryCode,
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
    required this.count,
    required this.categories,
    required this.domains,
  });

  factory UserDataEntity.fromJson(Map<String, dynamic> json) {
    return UserDataEntity(
        profileUrl: json['profileUrl'] ?? "",
        countryCode: json['countryCode'] ?? "",
        id: json['_id'] ?? "",
        phoneNumber: json['phoneNumber'] ?? "",
        verified: json['verified'] ?? "",
        kycStatus: json['kycStatus'] ?? false,
        wallet: json['wallet'] ?? "",
        mPin: json['mPin'] == 'false' ? false : true,
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
        v: json['__v'],
        role: (json['role'] != null) ? Role.fromJson(json['role']) : null,
        kyc: (json['kyc'] != null) ? Kyc.fromJson(json['kyc']) : null,
        count: Count.fromJson(json['count']),
        categories: json['categories'] != null && json["categories"].length > 0
            ? List<CategoryEntity>.from(json["categories"]!.map((x) => CategoryEntity.fromJson(x)))
            : [],
        domains: json['domains'] != null && json["domains"].length > 0
            ? List<DomainData>.from(json["domains"]!.map((x) => DomainData.fromJson(x)))
            : []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profileUrl'] = profileUrl;
    data['countryCode'] = countryCode;
    data['_id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['verified'] = verified;
    data['kycStatus'] = kycStatus;
    data['mPin'] = mPin;
    data['wallet'] = wallet;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['__v'] = v;
    data['role'] = role?.toJson();
    data['kyc'] = kyc?.toJson();
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

class Count {
  String course;
  String scholarship;
  String retail;
  String job;
  String orders;

  Count({
    required this.course,
    required this.scholarship,
    required this.retail,
    required this.job,
    required this.orders,
  });

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(
      course: json['course'],
      scholarship: json['scholarship'],
      retail: json['retail'],
      job: json['job'],
      orders: json['orders'] ?? "0",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course'] = course;
    data['scholarship'] = scholarship;
    data['retail'] = retail;
    data['job'] = job;
    data['orders'] = orders;
    return data;
  }
}
