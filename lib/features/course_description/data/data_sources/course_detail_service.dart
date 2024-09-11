import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../domain/entity/get_details_entity.dart';

/// [CourseDetailsRepository] for Api Calls
abstract class CourseDetailsApiService {
  Future<CourseDetailsEntity> getCourseDetails(String body);
}

class CourseDetailsApiServiceImpl implements CourseDetailsApiService {
  CourseDetailsApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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
  Future<CourseDetailsEntity> getCourseDetails(String itemId) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }
      AppUtils.printLogs("Home User Data token==>$authToken");

      AppUtils.printLogs("Apply search entity ${itemId.toString()}");
      AppUtils.printLogs("Apply search entity $getOrderDetailsApi");
      AppUtils.printLogs("Apply search entity ${sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId)}");

      final response = await dio.get(
        getOrderDetailsApi,
        queryParameters: {
          'deviceId': sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
          'itemId': itemId,
          // Add your query parameters here
        },
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );
      AppUtils.printLogs("Apply Search---->Response of seeker search  ${response.data}");

      return CourseDetailsEntity.fromJson(response.data);
    } catch (e) {
      AppUtils.printLogs("Apply search----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }
}
