class EAuthProviderModel {
  final String code;
  final String iconLink;
  final String title;
  final String subTitle;
  final String redirectUrl;

  EAuthProviderModel({
    required this.code,
    required this.iconLink,
    required this.title,
    required this.subTitle,
    required this.redirectUrl,
  });

  factory EAuthProviderModel.fromJson(Map<String, dynamic> json) {
    return EAuthProviderModel(
      code: json['code'],
      iconLink: json['iconLink'],
      title: json['title'],
      subTitle: json['subTitle'],
      redirectUrl: json['redirectUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'iconLink': iconLink,
      'title': title,
      'subTitle': subTitle,
      'redirectUrl': redirectUrl,
    };
  }
}

class AuthProviderResponseModel {
  final bool success;
  final String message;
  final EAuthProviderModel providers;

  AuthProviderResponseModel({
    required this.success,
    required this.message,
    required this.providers,
  });

  factory AuthProviderResponseModel.fromJson(Map<String, dynamic> json) {
    // List<EAuthProviderModel> providers = (json['data'] as List<dynamic>)
    //     .map((provider) => EAuthProviderModel.fromJson(provider))
    //     .toList();
    return AuthProviderResponseModel(
      success: json['success'],
      message: json['message'],
      providers: EAuthProviderModel.fromJson(json['data']),
    );
  }
}