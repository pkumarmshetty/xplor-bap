import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';

/// Implementation of the ProfileApiService.
abstract class ProfileApiService {
  Future<UserDataEntity> getUserData();

  Future<void> logout();
}

/// Implementation of the ProfileApiServiceImpl.
class ProfileApiServiceImpl implements ProfileApiService {
  ProfileApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
    /// Add interceptors
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

  /// Fetches the user's profile data.
  @override
  Future<UserDataEntity> getUserData() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Profile User Data token==>$authToken");
      final response = await dio.get(
        userDataApi,
        //queryParameters: {"translate": false},
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Profile User Data----> Response ${response.data}");

      UserDataEntity userData = UserDataEntity.fromJson(response.data["data"]);

      return userData;
    } catch (e) {
      AppUtils.printLogs("Profile----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Performs a logout action for the user.
  @override
  Future<void> logout() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Logout token==>$authToken");
      final response = await dio.put(
        logoutApi,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Logout----> Response ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Logout----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }
}
