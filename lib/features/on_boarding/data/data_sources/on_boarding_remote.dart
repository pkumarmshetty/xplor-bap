import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/exception_errors.dart';

import '../../../../const/local_storage/pref_const_key.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import '../../../../features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import '../../../on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import '../../domain/entities/on_boarding_user_role_entity.dart';
import '../models/e_auth_providers_model.dart';

abstract class OnBoardingApiService {
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity entity);

  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity);

  Future<void> getUserJourney();

  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity);

  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding();

  Future<bool> updateUserKycOnBoarding();

  Future<EAuthProviderModel?> getEAuthProviders();
}

class OnBoardingApiServiceImpl implements OnBoardingApiService {
  OnBoardingApiServiceImpl(
      {required this.dio, required this.preferencesHelper, this.helper});

  Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  @override
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("OnBoarding Body Data ${entity.toJson()}");
      }

      final response = await dio.post(
        sendOtpApi,
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

  @override
  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("verifyOtpOnBoarding Body Data $entity");
      }

      final response = await dio.post(
        verifyOtpApi,
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

      if (helper != null) {
        await helper!
            .setString(PrefConstKeys.token, response.data["data"]["token"]);
        await helper!
            .setString(PrefConstKeys.userId, response.data["data"]["userId"]);
      } else {
        await preferencesHelper.setString(
            PrefConstKeys.token, response.data["data"]["token"]);
        await preferencesHelper.setString(
            PrefConstKeys.userId, response.data["data"]["userId"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("verifyOtpOnBoarding----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<void> getUserJourney() async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.token)
        : helper!.getString(PrefConstKeys.token);
    if (kDebugMode) {
      print(authToken);
    }
    try {
      final response = await dio.get(
        getUserJourneyApi,
        options: Options(
          headers: {
            'Authorization': authToken,
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

      if (helper != null) {
        await helper!.setBool(
            PrefConstKeys.kycVerified, response.data["data"]["kycVerified"]);
        await helper!.setBool(PrefConstKeys.roleAssigned,
            response.data["data"]["personaCreated"]);
      } else {
        await preferencesHelper.setBoolean(
            PrefConstKeys.kycVerified, response.data["data"]["kycVerified"]);
        await preferencesHelper.setBoolean(PrefConstKeys.roleAssigned,
            response.data["data"]["personaCreated"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("getUserJourney----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("assignRoleOnBoarding Body Data $entity");
      }

      String? authToken;
      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
      }

      final response = await dio.patch(
        assignRoleApi,
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
        final String errorMessage = responseData['message'] ?? unknownError;
        throw Exception(errorMessage);
      } else {
        throw Exception(unknownErrorOccurred);
      }
    } catch (e) {
      if (kDebugMode) {
        print("assignRoleOnBoarding----> Catch ${handleError(e)}");
        return false;
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    try {
      final authToken = helper == null
          ? preferencesHelper.getString(PrefConstKeys.token)
          : helper!.getString(PrefConstKeys.token);

      final response = await dio.get(
        getUserRoleApi,
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
        final String errorMessage = responseData['message'] ?? unknownError;
        throw Exception(errorMessage);
      } else {
        throw Exception(unknownErrorOccurred);
      }
    } catch (e) {
      if (kDebugMode) {
        print("getUserRolesOnBoarding----> Catch $e");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<EAuthProviderModel?> getEAuthProviders() async {
    try {
      final authToken =
          sl<SharedPreferencesHelper>().getString(PrefConstKeys.token);

      if (authToken.isEmpty) {
        throw Exception("Authorization token is missing or invalid.");
      }
      final response = await dio.get(
        getAuthProvidersApi,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": authToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("getEAuthProviders----> Success 200 ${response.data}");

          return AuthProviderResponseModel.fromJson(response.data).providers;
        }
        return null;
      }

      if (response.statusCode == 400) {
        final Map<String, dynamic> responseData = json.decode(response.data);
        final String errorMessage = responseData['message'] ?? unknownError;
        throw Exception(errorMessage);
      } else {
        throw Exception(unknownErrorOccurred);
      }
    } catch (e) {
      if (kDebugMode) {
        print("getEAuthProviders----> Catch $e");
      }
      return null; // Return false for any error
    }
  }

  @override
  Future<bool> updateUserKycOnBoarding() async {
    try {
      final authToken = helper == null
          ? preferencesHelper.getString(PrefConstKeys.token)
          : helper!.getString(PrefConstKeys.token);
      final response = await dio.patch(
        verifyKycApi,
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
        final String errorMessage = responseData['message'] ?? unknownError;
        throw Exception(errorMessage);
      } else {
        throw Exception(unknownErrorOccurred);
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
