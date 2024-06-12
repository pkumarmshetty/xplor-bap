class ItemTagData {
  final Level level;
  final CourseDuration duration;
  final List<ItemTagList> list;

  ItemTagData({
    required this.level,
    required this.duration,
    required this.list,
  });

  factory ItemTagData.fromJson(Map<String, dynamic> json) {
    return ItemTagData(
        level: json['level'] == null ? Level(name: "", value: "Beginner") : Level.fromJson(json['level']),
        duration: json['duration'] == null
            ? CourseDuration(name: '', value: '0.0')
            : CourseDuration.fromJson(json['duration']),
        list: json['list'] == null ? [] : List<ItemTagList>.from(json["list"]!.map((x) => ItemTagList.fromJson(x))));
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level.toJson(),
      'duration': duration.toJson(),
      'list': list.map((item) => item.toJson()).toList(),
    };
  }
}

class Level {
  final String name;
  final String value;

  Level({
    required this.name,
    required this.value,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      name: json['name'] ?? "",
      value: json['value'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class CourseDuration {
  final String name;
  final String value;

  CourseDuration({
    required this.name,
    required this.value,
  });

  factory CourseDuration.fromJson(Map<String, dynamic> json) {
    return CourseDuration(
      name: json['name'] ?? "",
      value: json['value'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class ItemTagList {
  final Descriptor? descriptor;
  final String value;

  ItemTagList({
    required this.descriptor,
    required this.value,
  });

  factory ItemTagList.fromJson(Map<String, dynamic> json) {
    return ItemTagList(
      descriptor: json['descriptor'] == null ? null : Descriptor.fromJson(json['descriptor']),
      value: json['value'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descriptor': descriptor!.toJson(),
      'value': value,
    };
  }
}

class Descriptor {
  final String code;
  final String name;

  Descriptor({
    required this.code,
    required this.name,
  });

  factory Descriptor.fromJson(Map<String, dynamic> json) {
    return Descriptor(
      code: json['code'] ?? "",
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}
