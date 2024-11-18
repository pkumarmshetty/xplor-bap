import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import '../../../../features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import '../../domain/entities/categories_entity.dart';
import '../../domain/entities/domains_entity.dart';
import '../../domain/entities/kyc_sse_response.dart';
import '../../domain/entities/on_boarding_user_role_entity.dart';
import '../models/e_auth_providers_model.dart';

abstract class OnBoardingApiService {
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity entity);

  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity);

  Future<void> getUserJourney();

  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity);

  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding();

  Future<bool> updateUserKycOnBoarding();

  Future<bool> createMpin(String pin);

  Future<EAuthProviderModel?> getEAuthProviders();

  Future<void> getAssignedRoleUserData();

  Future<bool> updateDevicePreference(Map<String, dynamic> data);

  Future<List<DomainData>> getDomainsList();

  Future<bool> getDeviceInfo(String deviceId);

  Future<List<CategoryEntity>> getCategories();

  Future<void> onCategoriesSave(List<String> categories);

  Future<UserDataEntity> getUserData();

  Stream<KycSseResponse> getKycSuccessStatus(Duration timeout);
}

class OnBoardingApiServiceImpl implements OnBoardingApiService {
  OnBoardingApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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

  Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  @override
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      AppUtils.printLogs("OnBoarding Body Data ${entity.toJson()}");
      AppUtils.printLogs("OnBoarding Body Data $sendOtpApi");

      final response = await dio.post(
        sendOtpApi,
        data: jsonData,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      AppUtils.printLogs("sendOtpOnBoarding---->Response of sendOtpOnBoarding  ${response.data}");

      return response.data != null ? response.data["data"]["key"] : "";
    } catch (e) {
      AppUtils.printLogs("sendOtpOnBoarding----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      AppUtils.printLogs("verifyOtpOnBoarding Body Data $jsonData");

      final response = await dio.post(
        verifyOtpApi,
        data: jsonData,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      AppUtils.printLogs("verifyOtpOnBoarding---->Response of sendOtpOnBoarding  ${response.data}");

      if (helper != null) {
        await helper!.setString(PrefConstKeys.accessToken, response.data["data"]["accessToken"]);
        await helper!.setString(PrefConstKeys.refreshToken, response.data["data"]["refreshToken"]);
        await helper!.setString(PrefConstKeys.userId, response.data["data"]["userId"]);
      } else {
        await preferencesHelper.setString(PrefConstKeys.accessToken, response.data["data"]["accessToken"]);
        await preferencesHelper.setString(PrefConstKeys.refreshToken, response.data["data"]["refreshToken"]);
        await preferencesHelper.setString(PrefConstKeys.userId, response.data["data"]["userId"]);
      }
    } catch (e) {
      AppUtils.printLogs("verifyOtpOnBoarding----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<void> getAssignedRoleUserData() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Role Assigned User token==>$authToken");
      final response = await dio.get(
        userDataApi,
        //queryParameters: {"translate": false},
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (helper != null) {
        await helper!.setString(PrefConstKeys.role, response.data["data"]["role"]["type"]);
      } else {
        await preferencesHelper.setString(PrefConstKeys.role, response.data["data"]["role"]["type"]);
      }
    } catch (e) {
      AppUtils.printLogs("Role Assigned User----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<void> getUserJourney() async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.accessToken)
        : helper!.getString(PrefConstKeys.accessToken);
    AppUtils.printLogs(authToken.toString());
    try {
      final response = await dio.get(
        getUserJourneyApi,
        options: Options(
          headers: {
            'Authorization': authToken,
          },
        ),
      );

      AppUtils.printLogs("getUserJourney---->Response of getUserJourney  ${response.data}");
      if (helper != null) {
        await helper!.setBool(PrefConstKeys.kycVerified, response.data["data"]["kycVerified"]);
        await helper!.setBool(PrefConstKeys.roleAssigned, response.data["data"]["roleAssigned"]);
        await helper!.setBool(PrefConstKeys.isMpinCreated, response.data["data"]["mPinCreated"]);
      } else {
        await preferencesHelper.setBoolean(PrefConstKeys.kycVerified, response.data["data"]["kycVerified"]);
        await preferencesHelper.setBoolean(PrefConstKeys.roleAssigned, response.data["data"]["roleAssigned"]);
        await preferencesHelper.setBoolean(PrefConstKeys.isMpinCreated, response.data["data"]["mPinCreated"]);
      }
    } catch (e) {
      AppUtils.printLogs("getUserJourney----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity) async {
    try {
      var jsonData = json.encode(entity.toJson());

      AppUtils.printLogs("assignRoleOnBoarding Body Data $jsonData");

      final response = await dio.patch(
        updateDevicePreferenceApi,
        data: jsonData,
      );
      if (response.statusCode == 200) {
        AppUtils.printLogs("assignRoleOnBoarding----> Success 200 ${response.data}");
        return true;
      }
      return true;
    } catch (e) {
      AppUtils.printLogs("assignRoleOnBoarding----> Catch ${AppUtils.handleError(e)}");
      // return false;
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Stream<KycSseResponse> getKycSuccessStatus(Duration timeout) {
    final StreamController<KycSseResponse> stringStream = StreamController.broadcast();

    String? authToken;

    if (helper != null) {
      authToken = helper!.getString(PrefConstKeys.accessToken);
    } else {
      authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
    }

    AppUtils.printLogs("Kyc Api URL $sseKycApi");

    // Start a timer to enforce the timeout
    final timer = Timer(timeout, () {
      stringStream.addError(ExceptionErrors.checkTimeOut.stringToString);
      stringStream.close();
      //throw TimeoutException('Connection timed out after $timeout');
    });

    try {
      //GET REQUEST
      SSEClient.unsubscribeFromSSE();
      SSEClient.subscribeToSSE(method: SSERequestType.GET, url: sseKycApi, header: {
        "Authorization": authToken!,
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      }).listen(
        (event) {
          AppUtils.printLogs('Data: ${event.data!}');

          AppUtils.printLogs("Kyc Api Response ${event.data}");

          try {
            // Parse JSON string into Map
            var response = json.decode(event.data!);

            AppUtils.printLogs("Kyc Api Response Decode ${event.data}");

            if (response['success'] != null && response['success']) {
            } else {
              KycSseResponse model;
              model = KycSseResponse.fromJson(json.decode(event.data!));
              stringStream.add(model);
              timer.cancel();
            }
          } catch (e) {
            stringStream.addError(ExceptionErrors.checkTimeOut.stringToString);
            stringStream.close();
          }
        },
        onError: (error) {
          // Ensure the stream is closed on error
          AppUtils.printLogs('SSE Error: $error');

          stringStream.addError(error);
          stringStream.close();
          //throw Exception("SSE Connection Closed");
        },
        cancelOnError: true,
      );
    } on TimeoutException catch (e) {
      // Handle the timeout
      AppUtils.printLogs('TimeoutException: $e');
      stringStream.addError(ExceptionErrors.checkTimeOut.stringToString);
      stringStream.close();
    } catch (e) {
      stringStream.addError(e);
      stringStream.close();
      log(e.toString());
      log("Exception  ${e.toString()}");
    }
    return stringStream.stream;
  }

  @override
  Future<bool> updateDevicePreference(Map<String, dynamic> data) async {
    try {
      AppUtils.printLogs("updateDevicePreference Body Data $data");

      final response = await dio.patch(
        updateDevicePreferenceApi,
        data: data,
      );
      if (response.statusCode == 200) {
        AppUtils.printLogs("updateDevicePreference----> Success 200 ${response.data}");
        return true;
      }
      return true;
    } catch (e) {
      AppUtils.printLogs("updateDevicePreference----> Catch ${AppUtils.handleError(e)}");
      //return false;
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    try {
      String deviceId;
      if (helper != null) {
        deviceId = helper!.getString(PrefConstKeys.deviceId)!;
      } else {
        deviceId = preferencesHelper.getString(PrefConstKeys.deviceId);
      }

      final response = await dio.get(
        '$getUserRoleApi?deviceId=$deviceId',
      );
      List<dynamic> data = response.data['data'];
      List<OnBoardingUserRoleEntity> userRoles = data.map((json) => OnBoardingUserRoleEntity.fromJson(json)).toList();
      return userRoles;
    } catch (e) {
      AppUtils.printLogs("getUserRolesOnBoarding----> Catch $e");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<EAuthProviderModel?> getEAuthProviders() async {
    try {
      final authToken = helper == null
          ? preferencesHelper.getString(PrefConstKeys.accessToken)
          : helper!.getString(PrefConstKeys.accessToken);

      if (authToken == null) {
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

      return AuthProviderResponseModel.fromJson(response.data).providers;
    } catch (e) {
      AppUtils.printLogs("getEAuthProviders----> Catch $e");
      return null; // Return false for any error
    }
  }

  @override
  Future<bool> updateUserKycOnBoarding() async {
    try {
      final authToken = helper == null
          ? preferencesHelper.getString(PrefConstKeys.accessToken)
          : helper!.getString(PrefConstKeys.accessToken);
      await dio.patch(
        verifyKycApi,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": authToken,
          },
        ),
      );

      return true;
    } catch (e) {
      AppUtils.printLogs("updateUserKycOnBoarding----> Catch $e");
      return false; // Return false for any error
    }
  }

  @override
  Future<bool> createMpin(String pin) async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.accessToken)
        : helper!.getString(PrefConstKeys.accessToken);
    try {
      Map<String, dynamic> data = {
        'mPin': pin.toString(),
      };
      String jsonData = json.encode(data);

      AppUtils.printLogs("generate mpin: $pin");

      final response = await dio.post(
        generateMpinApi,
        data: jsonData,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );

      if (helper != null) {
        await helper!.setString(PrefConstKeys.userMpin, pin);
        await helper!.setBool(PrefConstKeys.isMpinCreated, true);
      } else {
        await preferencesHelper.setString(PrefConstKeys.userMpin, pin);
        await preferencesHelper.setBoolean(PrefConstKeys.isMpinCreated, true);
      }
      AppUtils.printLogs("generate mpin----> Success 200");
      AppUtils.printLogs("generate mpin---->data  ${response.data}");
      return true;
    } catch (e) {
      AppUtils.printLogs("generateMpin----> Catch $e");
      return false;
    }
  }

  @override
  Future<List<DomainData>> getDomainsList() async {
    try {
      String deviceId;

      if (helper != null) {
        deviceId = helper!.getString(PrefConstKeys.deviceId)!;
      } else {
        deviceId = preferencesHelper.getString(PrefConstKeys.deviceId);
      }

      final response = await dio.get(
        '$getDomainsApi?deviceId=$deviceId',
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );
      AppUtils.printLogs("Domains list Data----> Response ${response.data}");

      List<dynamic> domains = response.data['data'];
      return domains.map((domain) => DomainData.fromJson(domain)).toList();
    } catch (e) {
      AppUtils.printLogs("Domain----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<bool> getDeviceInfo(String deviceId) async {
    try {
      AppUtils.printLogs("url  ${"$updateDevicePreferenceApi/$deviceId"}");

      final response = await dio.get(
        "$updateDevicePreferenceApi/$deviceId",
      );
      AppUtils.printLogs("Domains list Data----> Response ${response.data}");

      //use patch api update
      if (response.data['data'] != null) {
        /*sl<SharedPreferencesHelper>().setString(
            PrefConstKeys.sourceLanguageCode,
            response.data['data']['languageCode']);*/
        return true;
      }

      //use post api
      return false;
    } catch (e) {
      AppUtils.printLogs("Domain----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      String deviceId;
      if (helper != null) {
        deviceId = helper!.getString(PrefConstKeys.deviceId)!;
      } else {
        deviceId = preferencesHelper.getString(PrefConstKeys.deviceId);
      }

      final response = await dio.get(
        '$getCategoriesApi?deviceId=$deviceId',
      );
      AppUtils.printLogs("Get Categories Data----> Response ${response.data["data"]}");
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data["data"];

        final List<CategoryEntity> categories = responseData.map((categoryJson) {
          return CategoryEntity(
            id: categoryJson['_id'] as String,
            category: categoryJson['title'] as String,
            value: categoryJson['value'] as String,
            isSelected: false,
          );
        }).toList();
        return categories;
      } else {
        throw Exception('Failed to fetch skills');
      }
    } catch (e) {
      AppUtils.printLogs("Get Categories----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<void> onCategoriesSave(List<String> categories) async {
    try {
      String? deviceId;

      if (helper != null) {
        deviceId = helper!.getString(PrefConstKeys.deviceId);
      } else {
        deviceId = preferencesHelper.getString(PrefConstKeys.deviceId);
      }

      final response = await dio.patch(
        updateDevicePreferenceApi,
        data: {
          'deviceId': deviceId,
          'categories': categories,
        },
      );
      AppUtils.printLogs("on Categories save----> Response ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Categories----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<UserDataEntity> getUserData() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Role Assigned User token==>$authToken");

      final response = await dio.get(
        userDataApi,
        // queryParameters: {"translate": false},
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("User Data----> Response ${response.data}");

      UserDataEntity userDataEntity = UserDataEntity.fromJson(response.data["data"]);
      return userDataEntity;
    } catch (e) {
      AppUtils.printLogs("User Data----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }
}
