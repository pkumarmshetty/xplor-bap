import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/exception_errors.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../domain/entities/profile_user_data_entity.dart';

abstract class ProfileApiService {
  Future<ProfileUserDataEntity> getUserData();
}

class ProfileApiServiceImpl implements ProfileApiService {
  ProfileApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper});

  Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  @override
  Future<ProfileUserDataEntity> getUserData() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
      }

      if (kDebugMode) {
        print("Profile User Data token==>$authToken");
      }
      final response = await dio.get(
        userDataApi,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Profile User Data----> Response ${response.data}");
      }

      ProfileUserDataEntity userData = ProfileUserDataEntity.fromJson(response.data["data"]);

      return userData;
    } catch (e) {
      if (kDebugMode) {
        print("Profile----> Catch ${handleError(e)}");
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
