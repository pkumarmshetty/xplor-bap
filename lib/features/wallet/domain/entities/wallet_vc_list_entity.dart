class DocumentVcResponse {
  bool success;
  String message;
  List<DocumentVcData> data;

  DocumentVcResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DocumentVcResponse.fromJson(Map<String, dynamic> json) {
    List<DocumentVcData> dataList = [];
    if (json['data'] != null) {
      dataList = List<DocumentVcData>.from(json['data'].map((data) => DocumentVcData.fromJson(data)));
    }
    return DocumentVcResponse(
      success: json['success'],
      message: json['message'],
      data: dataList,
    );
  }
}

// Define the document data class
class DocumentVcData {
  String? fileType;
  String id;
  String? did;
  String? fileId;
  String? walletId;
  String? type;
  String? category;
  List<String> tags;
  String name;
  String? iconUrl;
  String? templateId;
  String? restrictedUrl;
  String? createdAt;
  String? updatedAt;
  int? version;
  bool? isSelected;

  DocumentVcData({
    this.fileType,
    this.id = "",
    this.did,
    this.fileId,
    this.walletId,
    this.type,
    this.category,
    required this.tags,
    this.name = "Name",
    this.iconUrl,
    this.templateId,
    this.restrictedUrl,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.isSelected = false,
  });

  factory DocumentVcData.fromJson(Map<String, dynamic> json) {
    return DocumentVcData(
      fileType: json['fileType'],
      id: json['_id'],
      did: json['did'],
      fileId: json['fileId'],
      walletId: json['walletId'],
      type: json['type'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
      name: json['name'],
      iconUrl: json['iconUrl'],
      templateId: json['templateId'],
      restrictedUrl: json['restrictedUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'] ?? 0,
    );
  }

  DocumentVcData copyWith(
      {String? fileType,
      String? id,
      String? did,
      String? fileId,
      String? walletId,
      String? type,
      String? category,
      List<String>? tags,
      String? name,
      String? iconUrl,
      String? templateId,
      String? restrictedUrl,
      String? createdAt,
      String? updatedAt,
      int? version,
      bool? isSelected}) {
    return DocumentVcData(
      fileType: fileType ?? this.fileType,
      id: id ?? this.id,
      did: did ?? this.did,
      fileId: fileId ?? this.fileId,
      walletId: walletId ?? this.walletId,
      type: type ?? this.type,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
      templateId: templateId ?? this.templateId,
      restrictedUrl: restrictedUrl ?? this.restrictedUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
