import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/core/api_constants.dart';
import 'package:xplor/core/connection/refresh_token_service.dart';
import 'package:xplor/core/exception_errors.dart';
import 'package:xplor/features/mpin/domain/entities/send_mpin_otp_entity.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

class MpinApiService {
  Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  MpinApiService({
    required this.dio,
    required this.preferencesHelper,
    this.helper,
  }) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        handler.next(options);
      },
      onError: (DioException dioException, ErrorInterceptorHandler errorInterceptorHandler) async {
        if (dioException.response?.statusCode == 511) {
          await RefreshTokenService.refreshTokenAndRetry(
            options: dioException.response!.requestOptions,
            preferencesHelper: preferencesHelper,
            helper: helper,
            dio: dio,
            handler: errorInterceptorHandler,
          );
        } else {
          errorInterceptorHandler.next(dioException);
        }
      },
      onResponse: (response, handler) async {
        // Handle response, check for token expiration
        if (response.statusCode == 511) {
          // Token expired, refresh token
          await RefreshTokenService.refreshTokenAndRetry(
            options: response.requestOptions,
            preferencesHelper: preferencesHelper,
            helper: helper,
            dio: dio,
            handler: handler,
          );
        } else {
          handler.next(response);
        }
      },
    ));
  }

  Future<SendResetMpinOtpEntity> sendResetMpinOtp() async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.accessToken)
        : helper!.getString(PrefConstKeys.accessToken);

    try {
      if (kDebugMode) {
        print("send otp to reset mpin: $sendMpinOtp");
      }

      final response = await dio.put(
        sendMpinOtp,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );

      if (kDebugMode) {
        print("send otp to reset mpin response ${response.data}");
      }
      SendResetMpinOtpEntity resetMpinOtpResult = SendResetMpinOtpEntity.fromJson(response.data['data']);
      return resetMpinOtpResult;
    } catch (e) {
      if (kDebugMode) {
        print("send otp to reset Mpin failed----> Catch $e");
      }
      throw Exception(handleError(e));
    }
  }

  Future<String> verifyMpinOtp(SendResetMpinOtpEntity input) async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.accessToken)
        : helper!.getString(PrefConstKeys.accessToken);

    try {
      Map<String, dynamic> queryParams = {
        'otpType': 'MPIN',
      };

      Map<String, dynamic> data = {
        'key': input.mpinKey,
        'otp': input.otp,
      };
      String jsonData = json.encode(data);

      if (kDebugMode) {
        print("verify mpin otp to reset mpin:  $jsonData");
        print("verify mpin otp to reset mpin:  $verifyOtpApi");
      }

      final response = await dio.post(
        verifyOtpApi,
        queryParameters: queryParams,
        data: jsonData,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );

      if (kDebugMode) {
        print("verify mpin otp to reset mpin response ${response.data}");
      }
      /* Map<String,dynamic> decodedResponse = json.decode(response.data['data']);
      String verifiedKey = decodedResponse['verifiedMpinKey'];*/
      String verifiedKey = response.data['data']['verifiedMpinKey'];
      return verifiedKey;
    } catch (e) {
      if (kDebugMode) {
        print("verify mpin otp to reset Mpin failed----> Catch $e");
      }
      throw Exception(handleError(e));
    }
  }

  Future<bool> resetMpin(String mPin, String verifiedKey) async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.accessToken)
        : helper!.getString(PrefConstKeys.accessToken);

    try {
      Map<String, dynamic> data = {
        'key': verifiedKey,
        'mPin': mPin,
      };
      String jsonData = json.encode(data);

      if (kDebugMode) {
        print("reset mpin api call:  $jsonData");
        print("reset mpin api call:  $resetPin");
      }

      final response = await dio.put(
        resetPin,
        data: jsonData,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );

      // if (helper != null) {
      //   await helper!.setString(PrefConstKeys.userMpin, pin);
      //   await helper!.setBool(PrefConstKeys.isMpinCreated, true);
      // } else {
      //   await preferencesHelper.setString(PrefConstKeys.userMpin, pin);
      //   await preferencesHelper.setBoolean(PrefConstKeys.isMpinCreated, true);
      // }
      if (kDebugMode) {
        print("mPin reset successfully response ${response.data}");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Reset mPin failed----> Catch $e");
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
          errorDescription = ExceptionErrors.requestCancelError.stringToString;

          return errorDescription;
        case DioExceptionType.connectionTimeout:
          errorDescription = ExceptionErrors.connectionTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription = ExceptionErrors.unknownConnectionError.stringToString;

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = ExceptionErrors.receiveTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print("${ExceptionErrors.badResponseError}  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = ExceptionErrors.sendTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = ExceptionErrors.badCertificate.stringToString;

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription = ExceptionErrors.serverConnectingIssue.stringToString;

          return errorDescription;
      }
    } else {
      errorDescription = ExceptionErrors.unexpectedErrorOccurred.stringToString;
      return errorDescription;
    }
  }
}
