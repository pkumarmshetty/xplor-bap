class StopsEntity {
  final String id;
  final InstructionDetail instructions;

  StopsEntity({required this.id, required this.instructions});

  factory StopsEntity.fromJson(Map<String, dynamic> json) {
    return StopsEntity(
      id: json['id'],
      instructions: InstructionDetail.fromJson(json['instructions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'instructions': instructions.toJson(),
    };
  }
}

class InstructionDetail {
  final String name;
  final String longDesc;
  final List<Media> media;

  InstructionDetail({required this.name, required this.longDesc, required this.media});

  factory InstructionDetail.fromJson(Map<String, dynamic> json) {
    var mediaList = json['media'] as List;
    List<Media> media = mediaList.map((i) => Media.fromJson(i)).toList();

    return InstructionDetail(
      name: json['name'],
      longDesc: json['long_desc'],
      media: media,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'long_desc': longDesc,
      'media': media.map((e) => e.toJson()).toList(),
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
