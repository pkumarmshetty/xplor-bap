import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';

import '../../../../core/api_constants.dart';
import '../../../../core/exception_errors.dart';
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
      debugPrint("debugPrint App ====>$body");
      final response = await dio.post(
        translationApi,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: body,
      );

      if (kDebugMode) {
        print("Translation Response====>${response.statusCode}");
        print("Translation Response====>${response.data}");
      }

      return response.data['translated_text'];
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  @override
  Future<List<LanguageTranslationModel>> getLanguageModel(String body) async {
    try {
      double lat, lng;

      /*if (helper != null) {
        lat = helper!.getDouble(PrefConstKeys.latitude)!;
        lng = helper!.getDouble(PrefConstKeys.longitude)!;
      } else {
        lat = preferencesHelper.getDouble(PrefConstKeys.latitude);
        lng = preferencesHelper.getDouble(PrefConstKeys.longitude);
      }*/
      Position pos = await Geolocator.getCurrentPosition();
      lat = pos.latitude; /*pos.latitude;*/
      lng = pos.longitude; /*pos.longitude;*/

      if (kDebugMode) {
        print("getLanguagesListApi  $getLanguagesListApi latat: $lat, Lng: $lng");
      }
      final response = await dio.get(
        getLanguagesListApi,
        queryParameters: {"lat": lat, "long": lng},
      );

      if (kDebugMode) {
        print("getLanguagesListApi Response====>${response.statusCode}");
        print("getLanguagesListApi Response====>${response.data}");
      }

      List<dynamic> data = response.data['data']['regionalLanguages'];

      List<LanguageTranslationModel> languageModel =
          data.map((json) => LanguageTranslationModel.fromJson(json)).toList();

      return languageModel;
    } catch (e) {
      throw Exception(handleError(e));
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

      if (kDebugMode) {
        print("json Body  $jsonBody");
      }

      if (kDebugMode) {
        print("selectLanguagesApi  $selectLanguagesApi");
      }
      final response = await dio.post(
        selectLanguagesApi,
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
        data: jsonBody,
      );

      if (kDebugMode) {
        print("Wallet App Response====>${response.statusCode}");
        print("Wallet App Response====>${response.data}");
      }

      return true;
    } catch (e) {
      throw Exception(handleError(e));
    }
  }

  String handleError(Object error) {
    String errorDescription = "";

    if (error is DioException) {
      DioException dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = ExceptionErrors.requestCancelError;

          return errorDescription;
        case DioExceptionType.connectionTimeout:
          errorDescription = ExceptionErrors.connectionTimeOutError;

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription = ExceptionErrors.unknownConnectionError;

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = ExceptionErrors.receiveTimeOutError;

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print("${ExceptionErrors.badResponseError}  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = ExceptionErrors.sendTimeOutError;

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = ExceptionErrors.badCertificate;

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription = ExceptionErrors.serverConnectingIssue;

          return errorDescription;
      }
    } else {
      errorDescription = ExceptionErrors.unexpectedErrorOccurred;
      return errorDescription;
    }
  }
}
