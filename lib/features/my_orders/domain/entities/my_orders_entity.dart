/// Entity class for My Orders feature.
class MyOrdersListEntity {
  final List<MyOrdersEntity> myOrders;
  final int totalCount;

  MyOrdersListEntity({required this.myOrders, required this.totalCount});

  factory MyOrdersListEntity.fromJson(Map<String, dynamic> json) {
    return MyOrdersListEntity(
      totalCount: json['totalCount'] ?? 0,
      myOrders: json['orders'] == null
          ? []
          : List<MyOrdersEntity>.from(json['orders'].map((i) => MyOrdersEntity.fromJson(i))),
    );
  }
}

class MyOrdersEntity {
  String? id;
  String? orderId;
  String? domain;
  String? transactionId;
  Rating? rating;
  bool? isAddedToWallet;
  String? certificateUrl;
  ItemDetails? itemDetails;
  Fulfillment? fulfillment;
  double? courseProgress;

  MyOrdersEntity(
      {this.id,
      this.orderId,
      this.domain,
      this.transactionId,
      this.rating,
      this.isAddedToWallet,
      this.certificateUrl,
      this.itemDetails,
      this.fulfillment,
      this.courseProgress});

  factory MyOrdersEntity.fromJson(Map<String, dynamic> json) {
    return MyOrdersEntity(
      id: json['_id'] ?? "",
      orderId: json['order_id'] ?? "",
      domain: json['domain'] ?? "",
      transactionId: json['transaction_id'] ?? "",
      isAddedToWallet: json['is_added_to_wallet'] ?? false,
      rating: json['rating'] == null ? null : Rating.fromJson(json['rating']),
      certificateUrl: json['certificate_url'] ?? "",
      itemDetails: json['item_details'] == null ? null : ItemDetails.fromJson(json['item_details']),
      fulfillment: json['fulfillment'] == null ? null : Fulfillment.fromJson(json['fulfillment']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'order_id': orderId,
      'rating': rating?.toJson(),
      'is_added_to_wallet': isAddedToWallet,
      'certificate_url': certificateUrl,
      'item_details': itemDetails?.toJson(),
      'fulfillment': fulfillment?.toJson(),
    };
  }
}

class Rating {
  String? rating;
  String? review;

  Rating({
    this.rating,
    this.review,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json['rating'] ?? "",
      review: json['review'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'review': review,
    };
  }
}

class ItemDetails {
  String? itemId;
  String? providerName;
  List<String>? providerImages;
  Descriptor? descriptor;

  ItemDetails({
    this.itemId,
    this.providerName,
    this.providerImages,
    this.descriptor,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      itemId: json['item_id'] ?? "",
      providerName: json['provider_name'] ?? "",
      providerImages: json['provider_images'] == null ? [] : List<String>.from(json['provider_images']),
      descriptor: json['descriptor'] == null ? null : Descriptor.fromJson(json['descriptor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'provider_name': providerName,
      'provider_images': providerImages,
      'descriptor': descriptor?.toJson(),
    };
  }
}

class Descriptor {
  String? name;
  String? longDesc;
  String? shortDesc;
  List<String>? images;

  Descriptor({
    this.name,
    this.longDesc,
    this.shortDesc,
    this.images,
  });

  factory Descriptor.fromJson(Map<String, dynamic> json) {
    return Descriptor(
      name: json['name'] ?? "",
      longDesc: json['long_desc'] ?? "",
      shortDesc: json['short_desc'] ?? "",
      images: json['images'] == null ? [] : List<String>.from(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'long_desc': longDesc,
      'short_desc': shortDesc,
      'images': images,
    };
  }
}

class Fulfillment {
  List<Media>? media;

  Fulfillment({this.media});

  factory Fulfillment.fromJson(Map<String, dynamic> json) {
    return Fulfillment(
      media: json['media'] == null ? [] : List<Media>.from(json['media'].map((i) => Media.fromJson(i))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media': media?.map((i) => i.toJson()).toList(),
    };
  }
}

class Media {
  final String url;
  final String mimetype;

  Media({
    required this.url,
    required this.mimetype,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      url: json['url'] ?? "",
      mimetype: json['mimetype'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
