import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/routes/path_routing.dart';
import '../../config/services/app_services.dart';
import '../../const/local_storage/shared_preferences_helper.dart';
import '../../utils/app_utils/app_utils.dart';
import '../api_constants.dart';

class RefreshTokenService {
  static Future<void> refreshTokenAndRetry({
    required RequestOptions options,
    required dynamic handler,
    SharedPreferencesHelper? preferencesHelper,
    SharedPreferences? helper,
    required Dio dio,
  }) async {
    try {
      // Call token refresh API endpoint
      // Assuming refreshToken() returns a new access token
      final newAccessToken = await refreshToken(
        preferencesHelper: preferencesHelper!,
        helper: helper,
        dio: dio,
      );

      // Update the access token in the request headers
      options.headers['Authorization'] = newAccessToken;

      // Create new Options object from RequestOptions
      final newOptions = Options(
        method: options.method,
        headers: options.headers,
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      );

      String? filePath;

      if (helper != null) {
        filePath = helper.getString(PrefConstKeys.filePath);
      } else {
        filePath = preferencesHelper.getString(PrefConstKeys.filePath);
      }

      if (options.data is FormData) {
        FormData formData = FormData();
        formData.fields.addAll(options.data.fields);
        //formData.files.addAll(options.data.files);
        // Create new MultipartFile objects for each file in the FormData
        for (MapEntry mapFile in options.data.files) {
          if (filePath != null && filePath.isNotEmpty) {
            String getMimeType(String filename) {
              // Use the lookupMimeType function from the mime package
              String? mimeType = lookupMimeType(filename);
              // Return the MIME type or a default value if it's null
              return mimeType ?? 'application/octet-stream';
            }

            String mimeType = getMimeType(filePath);
            formData.files.add(MapEntry(
              mapFile.key,
              await MultipartFile.fromFile(
                filePath,
                contentType: MediaType.parse(mimeType),
              ),
            ));
          }
        }

        final response = await dio.request(
          options.path,
          data: formData,
          queryParameters: options.queryParameters,
          options: newOptions,
        );
        handler.resolve(response);
      } else {
        final response = await dio.request(
          options.path,
          data: options.data,
          queryParameters: options.queryParameters,
          options: newOptions,
        );
        handler.resolve(response);
      }
    } catch (e) {
      AppUtils.printLogs("Token refresh failed: $e");
      AppUtils.printLogs("Refresh Token----> Exception ${e.toString()}");

      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          AppUtils.printLogs("Refresh Token Expired-->: ${e.message}");
          AppUtils.clearSession();
          Navigator.pushReplacementNamed(
            AppServices.navState.currentContext!,
            Routes.main,
          );
        } else {
          AppUtils.printLogs("Refresh Token----> Error: ${e.message}");
          handler.reject(e);
        }
      } else {
        // Check if the error message contains "401"
        if (e.toString().contains("401")) {
          AppUtils.printLogs("Refresh Token Expired-->: ${e.toString()}");
          AppUtils.clearSession();
          Navigator.pushReplacementNamed(
            AppServices.navState.currentContext!,
            Routes.main,
          );
        } else {
          AppUtils.printLogs("Refresh Token----> Error: ${e.toString()}");
          handler.reject(e);
        }
        AppUtils.printLogs("Refresh Token----> Error: ${e.toString()}");
        handler.reject(e);
      }
    }
  }

  static Future<String> refreshToken({
    required SharedPreferencesHelper preferencesHelper,
    required SharedPreferences? helper,
    required Dio dio,
  }) async {
    final authToken = helper != null
        ? helper.getString(PrefConstKeys.refreshToken)
        : preferencesHelper.getString(PrefConstKeys.refreshToken);
    try {
      final response = await dio.get(
        refreshTokenApi,
        options: Options(
          headers: {
            'Authorization': authToken,
          },
        ),
      );
      AppUtils.printLogs("Refresh Token----> Response ${response.data}");
      final newAccessToken = response.data["data"]["accessToken"];
      if (helper != null) {
        await helper.setString(
            PrefConstKeys.accessToken, response.data["data"]["accessToken"]);
      } else {
        await preferencesHelper.setString(
            PrefConstKeys.accessToken, response.data["data"]["accessToken"]);
      }
      return newAccessToken;
    } catch (e) {
      AppUtils.printLogs("Refresh Token----> Exception ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
