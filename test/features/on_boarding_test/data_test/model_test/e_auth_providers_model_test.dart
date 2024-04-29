import 'package:flutter_test/flutter_test.dart';
import 'package:xplor/features/on_boarding/data/models/e_auth_providers_model.dart';

void main() {
  group('EAuthProviderModel', () {
    test('fromJson() should correctly deserialize JSON', () {
      final Map<String, dynamic> json = {
        'code': 'example_code',
        'iconLink': 'example_icon_link',
        'title': 'Example Title',
        'subTitle': 'Example Subtitle',
        'redirectUrl': 'example_redirect_url',
      };

      final model = EAuthProviderModel.fromJson(json);

      expect(model.code, 'example_code');
      expect(model.iconLink, 'example_icon_link');
      expect(model.title, 'Example Title');
      expect(model.subTitle, 'Example Subtitle');
      expect(model.redirectUrl, 'example_redirect_url');
    });

    test('toJson() should correctly serialize to JSON', () {
      final model = EAuthProviderModel(
        code: 'example_code',
        iconLink: 'example_icon_link',
        title: 'Example Title',
        subTitle: 'Example Subtitle',
        redirectUrl: 'example_redirect_url',
      );

      final json = model.toJson();

      expect(json['code'], 'example_code');
      expect(json['iconLink'], 'example_icon_link');
      expect(json['title'], 'Example Title');
      expect(json['subTitle'], 'Example Subtitle');
      expect(json['redirectUrl'], 'example_redirect_url');
    });
  });

  group('AuthProviderResponseModel', () {
    test('fromJson() should correctly deserialize JSON', () {
      final Map<String, dynamic> json = {
        'success': true,
        'message': 'Example Message',
        'data': {
          'code': 'example_code',
          'iconLink': 'example_icon_link',
          'title': 'Example Title',
          'subTitle': 'Example Subtitle',
          'redirectUrl': 'example_redirect_url',
        },
      };

      final model = AuthProviderResponseModel.fromJson(json);

      expect(model.success, true);
      expect(model.message, 'Example Message');
      expect(model.providers.code, 'example_code');
      expect(model.providers.iconLink, 'example_icon_link');
      expect(model.providers.title, 'Example Title');
      expect(model.providers.subTitle, 'Example Subtitle');
      expect(model.providers.redirectUrl, 'example_redirect_url');
    });
  });
}
