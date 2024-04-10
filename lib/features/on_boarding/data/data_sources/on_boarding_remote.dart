import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';

import '../../../../const/local_storage/pref_const_key.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/dependency_injection.dart';
import '../../domain/entities/on_boarding_user_role_entity.dart';

class OnBoardingApiService {
  final Dio _dio = sl<Dio>();

  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("OnBoarding Body Data ${entity.toJson()}");
      }

      final response = await _dio.post(
        "${baseUrl}user/send-otp",
        data: jsonData,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      if (kDebugMode) {
        print(
            "sendOtpOnBoarding---->Response of sendOtpOnBoarding  ${response.data}");
      }

      return response.data != null ? response.data["data"]["key"] : "";
    } catch (e) {
      if (kDebugMode) {
        print("sendOtpOnBoarding----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  Future<void> resendOtpOnBoarding() async {
    try {
      Map<String, dynamic> entity = {
        "key": SharedPreferencesHelper().getString(PrefConstKeys.userKey),
      };

      if (kDebugMode) {
        print("resendOtpOnBoarding Body Data $entity");
      }

      final response = await _dio.post(
        "${baseUrl}user/resend-otp",
        data: entity,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print(
              "resendOtpOnBoarding----> Success 200 not found  ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("resendOtpOnBoarding----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("verifyOtpOnBoarding Body Data $entity");
      }

      final response = await _dio.post(
        "${baseUrl}user/verify-otp",
        data: jsonData,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print(
              "verifyOtpOnBoarding----> Success 200 not found  ${response.statusCode}");
        }
      }
      if (kDebugMode) {
        print(
            "verifyOtpOnBoarding---->Response of sendOtpOnBoarding  ${response.data}");
      }
      await SharedPreferencesHelper()
          .setString(PrefConstKeys.token, response.data["data"]["token"]);
      await SharedPreferencesHelper()
          .setString(PrefConstKeys.userId, response.data["data"]["userId"]);
    } catch (e) {
      if (kDebugMode) {
        print("verifyOtpOnBoarding----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  Future<void> getUserJourney() async {
    var token = SharedPreferencesHelper().getString(PrefConstKeys.token);
    if (kDebugMode) {
      print(token);
    }
    try {
      final response = await _dio.get(
        "${baseUrl}user/journey",
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print(
              "getUserJourney----> Success 200 not found  ${response.statusCode}");
        }
      }
      if (kDebugMode) {
        print(
            "getUserJourney---->Response of getUserJourney  ${response.data}");
      }
      await SharedPreferencesHelper().setBoolean(
          PrefConstKeys.kycVerified, response.data["data"]["kycVerified"]);
      await SharedPreferencesHelper().setBoolean(
          PrefConstKeys.roleAssigned, response.data["data"]["roleAssigned"]);
    } catch (e) {
      if (kDebugMode) {
        print("getUserJourney----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("assignRoleOnBoarding Body Data $entity");
      }

      final authToken =
          SharedPreferencesHelper().getString(PrefConstKeys.token);

      final response = await _dio.patch(
        "${baseUrl}user/role",
        data: jsonData,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("assignRoleOnBoarding----> Success 200 ${response.data}");
        }
        return true;
      }

      if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.data);
        final String errorMessage = responseData['message'] ?? 'Unknown error';
        throw Exception(errorMessage);
      } else {
        throw Exception('Unknown error occurred');
      }
    } catch (e) {
      if (kDebugMode) {
        print("assignRoleOnBoarding----> Catch ${handleError(e)}");
        return false;
      }
      throw Exception(handleError(e));
    }
  }

  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    try {
      final authToken =
          SharedPreferencesHelper().getString(PrefConstKeys.token);

      if (authToken.isEmpty) {
        throw Exception("Authorization token is missing or invalid.");
      }

      final response = await _dio.get(
        "${baseUrl}user/roles",
        options: Options(
          headers: {
            "Authorization": authToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        List<OnBoardingUserRoleEntity> userRoles = data
            .map((json) => OnBoardingUserRoleEntity.fromJson(json))
            .toList();
        return userRoles;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.data);
        final String errorMessage = responseData['message'] ?? 'Unknown error';
        throw Exception(errorMessage);
      } else {
        throw Exception('Unknown error occurred');
      }
    } catch (e) {
      if (kDebugMode) {
        print("getUserRolesOnBoarding----> Catch $e");
      }
      throw Exception(handleError(e));
    }
  }

  Future<bool> updateUserKycOnBoarding() async {
    try {
      final authToken =
          SharedPreferencesHelper().getString(PrefConstKeys.token);

      if (authToken.isEmpty) {
        throw Exception("Authorization token is missing or invalid.");
      }
      final response = await _dio.patch(
        "${baseUrl}user/kyc",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": authToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("updateUserKycOnBoarding----> Success 200 ${response.data}");
        }
        return true;
      }

      if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.data);
        final String errorMessage = responseData['message'] ?? 'Unknown error';
        throw Exception(errorMessage);
      } else {
        throw Exception('Unknown error occurred');
      }
    } catch (e) {
      if (kDebugMode) {
        print("updateUserKycOnBoarding----> Catch $e");
      }
      return false; // Return false for any error
    }
  }

  String handleError(Object error) {
    String errorDescription = "";

    if (error is DioException) {
      DioException dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request to API server was cancelled";

          return errorDescription;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout with API server";

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription =
              "Connection to API server failed due to internet connection";

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print("response.error  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = "Bad certificate";

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription = "Server connecting issues";

          return errorDescription;
      }
    } else {
      errorDescription = "Unexpected error occured";
      return errorDescription;
    }
  }
}
