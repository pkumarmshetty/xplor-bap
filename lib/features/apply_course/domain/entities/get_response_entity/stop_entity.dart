class StopsEntity {
  final String id;
  final InstructionDetail instructions;
  final Authorization? authorization;

  StopsEntity({required this.id, required this.instructions, required this.authorization});

  factory StopsEntity.fromJson(Map<String, dynamic> json) {
    return StopsEntity(
      id: json['id'],
      instructions: InstructionDetail.fromJson(json['instructions']),
      authorization: json['authorization'] != null ? Authorization.fromJson(json['authorization']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instructions': instructions.toJson(),
      'authorization': authorization?.toJson(),
    };
  }
}

class InstructionDetail {
  final String name;
  final List<Media> media;

  InstructionDetail({required this.name, required this.media});

  factory InstructionDetail.fromJson(Map<String, dynamic> json) {
    var mediaList = json['media'] as List;
    List<Media> media = mediaList.map((i) => Media.fromJson(i)).toList();

    return InstructionDetail(
      name: json['name'],
      media: media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'media': media.map((e) => e.toJson()).toList(),
    };
  }
}

class Authorization {
  final String status;

  Authorization({required this.status});

  factory Authorization.fromJson(Map<String, dynamic> json) {
    return Authorization(
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
    };
  }
}

class Media {
  final String url;

  Media({required this.url});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
