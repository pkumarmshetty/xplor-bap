import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../domain/entities/send_mpin_otp_entity.dart';
import '../../../../utils/app_utils/app_utils.dart';

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
      AppUtils.printLogs("send otp to reset mpin: $sendMpinOtp");

      final response = await dio.put(
        sendMpinOtp,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );

      AppUtils.printLogs("send otp to reset mpin response ${response.data}");
      SendResetMpinOtpEntity resetMpinOtpResult = SendResetMpinOtpEntity.fromJson(response.data['data']);
      return resetMpinOtpResult;
    } catch (e) {
      AppUtils.printLogs("send otp to reset Mpin failed----> Catch $e");
      throw Exception(AppUtils.handleError(e));
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

      AppUtils.printLogs("verify mpin otp to reset mpin:  $jsonData");
      AppUtils.printLogs("verify mpin otp to reset mpin:  $verifyOtpApi");

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

      AppUtils.printLogs("verify mpin otp to reset mpin response ${response.data}");
      /* Map<String,dynamic> decodedResponse = json.decode(response.data['data']);
      String verifiedKey = decodedResponse['verifiedMpinKey'];*/
      String verifiedKey = response.data['data']['verifiedMpinKey'];
      return verifiedKey;
    } catch (e) {
      AppUtils.printLogs("verify mpin otp to reset Mpin failed----> Catch $e");
      throw Exception(AppUtils.handleError(e));
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
      AppUtils.printLogs("reset mpin api call:  $jsonData");
      AppUtils.printLogs("reset mpin api call:  $resetPin");

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

      AppUtils.printLogs("mPin reset successfully response ${response.data}");
      return true;
    } catch (e) {
      AppUtils.printLogs("Reset mPin failed----> Catch $e");
      throw Exception(AppUtils.handleError(e));
    }
  }
}
