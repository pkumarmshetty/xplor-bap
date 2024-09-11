import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';

/// Home Api Services
abstract class HomeApiService {
  Future<UserDataEntity> getUserData();
}

class HomeApiServiceImpl implements HomeApiService {
  HomeApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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
  Future<UserDataEntity> getUserData() async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Home User Data token==>$authToken");

      final response = await dio.get(
        userDataApi,
        //queryParameters: {"translate": false},
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Home User Data----> Response ${response.data}");

      UserDataEntity userData = UserDataEntity.fromJson(response.data["data"]);
      if (helper != null) {
        helper!.setString(PrefConstKeys.phoneNumber, userData.phoneNumber ?? '');
      } else {
        preferencesHelper.setString(PrefConstKeys.phoneNumber, userData.phoneNumber ?? '');
      }
      return userData;
    } catch (e) {
      AppUtils.printLogs("Home----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }
}
