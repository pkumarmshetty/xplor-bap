import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/exception_errors.dart';
import '../../domain/entities/user_data_entity.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';

abstract class HomeApiService {
  Future<UserDataEntity> getUserData();
}

class HomeApiServiceImpl implements HomeApiService {
  HomeApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper});

  Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  @override
  Future<UserDataEntity> getUserData() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
      }

      if (kDebugMode) {
        print("Home User Data token==>$authToken");
      }
      final response = await dio.get(
        userDataApi,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Home User Data----> Response ${response.data}");
      }

      UserDataEntity userData = UserDataEntity.fromJson(response.data["data"]);

      return userData;
    } catch (e) {
      if (kDebugMode) {
        print("Home----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  String handleError(Object error) {
    String errorDescription = "";

    if (error is DioException) {
      DioException dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = requestCancelError;

          return errorDescription;
        case DioExceptionType.connectionTimeout:
          errorDescription = connectionTimeOutError;

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription = unknownConnectionError;

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = receiveTimeOutError;

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print("$badResponseError  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = sendTimeOutError;

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = badCertificate;

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription = serverConnectingIssue;

          return errorDescription;
      }
    } else {
      errorDescription = unexpectedErrorOccurred;
      return errorDescription;
    }
  }
}
