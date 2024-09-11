import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../models/lang_translation_model.dart';

abstract class LanguageTranslationRemote {
  Future<Map<String, dynamic>> translateMap(String body);

  Future<List<LanguageTranslationModel>> getLanguageModel(String body);

  Future<bool> selectedLanguageApi(String body);
}

class LanguageTranslationRemoteImpl extends LanguageTranslationRemote {
  final Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  LanguageTranslationRemoteImpl({required this.dio, required this.preferencesHelper, this.helper});

  @override
  Future<Map<String, dynamic>> translateMap(String body) async {
    try {
      AppUtils.printLogs("debugPrint App ====>$body");
      final response = await dio.post(
        translationApi,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: body,
      );

      AppUtils.printLogs("Translation Response====>${response.statusCode}");
      AppUtils.printLogs("Translation Response====>${response.data}");

      return response.data['translated_text'];
    } catch (e) {
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<List<LanguageTranslationModel>> getLanguageModel(String body) async {
    try {
      double lat, lng;
      Position pos = await Geolocator.getCurrentPosition();
      lat = pos.latitude;
      lng = pos.longitude;

      /*lat = 30.744600;
      lng = 76.652496;*/

      AppUtils.printLogs("getLanguagesListApi  $getLanguagesListApi latat: $lat, Lng: $lng");
      final response = await dio.get(
        getLanguagesListApi,
        queryParameters: {"lat": lat, "long": lng},
      );

      AppUtils.printLogs("getLanguagesListApi Response====>${response.statusCode}");
      AppUtils.printLogs("getLanguagesListApi Response====>${response.data}");

      List<dynamic> data = response.data['data']['regionalLanguages'];

      List<LanguageTranslationModel> languageModel =
          data.map((json) => LanguageTranslationModel.fromJson(json)).toList();

      return languageModel;
    } catch (e) {
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<bool> selectedLanguageApi(String body) async {
    try {
      String deviceId, languageCode;

      if (helper != null) {
        deviceId = helper!.getString(PrefConstKeys.deviceId)!;
        languageCode = helper!.getString(PrefConstKeys.selectedLanguageCode)!;
      } else {
        deviceId = preferencesHelper.getString(PrefConstKeys.deviceId);
        languageCode = preferencesHelper.getString(PrefConstKeys.selectedLanguageCode);
      }

      var jsonBody = json.encode({"deviceId": deviceId, "languageCode": languageCode});

      AppUtils.printLogs("json Body  $jsonBody");
      AppUtils.printLogs("selectLanguagesApi  $selectLanguagesApi");

      final response = await dio.post(
        selectLanguagesApi,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: jsonBody,
      );

      AppUtils.printLogs("Save language api Response====>${response.statusCode}");
      AppUtils.printLogs("Save language api Response====>${response.data}");

      return true;
    } catch (e) {
      throw Exception(AppUtils.handleError(e));
    }
  }
}
