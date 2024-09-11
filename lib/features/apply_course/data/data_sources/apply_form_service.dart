import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../core/exception_errors.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../domain/entities/get_response_entity/sse_services_entity.dart';

abstract class ApplyFormsApiService {
  Future<void> initRequest(String body);

  Future<void> confirmRequest(String body);

  Future<void> selectRequest(String body);

  Stream<SseServicesEntity> sseConnectionResponse(String transactionId, Duration timeout);
}

class ApplyFormsApiServiceImpl implements ApplyFormsApiService {
  ApplyFormsApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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
  Future<void> initRequest(String body) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Home User Data token==>$authToken");
      AppUtils.printLogs("Apply search entity ${body.toString()}");
      AppUtils.printLogs("Apply search entity $initRequestApi");

      final response = await dio.post(
        initRequestApi,
        data: body,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );
      AppUtils.printLogs("Apply Search---->Response of seeker search  ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Apply search----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<void> confirmRequest(String body) async {
    try {
      AppUtils.printLogs("Apply search entity ${body.toString()}");
      AppUtils.printLogs("Apply search entity $confirmRequestApi");
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      final response = await dio.post(
        confirmRequestApi,
        data: body,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );
      AppUtils.printLogs("Apply Search---->Response of seeker search  ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Apply search----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<dynamic> selectRequest(String body) async {
    try {
      AppUtils.printLogs("Apply select entity ${body.toString()}");
      AppUtils.printLogs("Apply select entity $selectRequestApi");

      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      final response = await dio.post(
        selectRequestApi,
        data: body,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );

      AppUtils.printLogs("Apply Search---->Response of seeker search  ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Apply search----> Catch ${AppUtils.handleError(e)}");

      // return Future.error(AppUtils.handleError(AppUtils.handleError(e)));
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Stream<SseServicesEntity> sseConnectionResponse(String transactionId, Duration timeout) {
    final StreamController<SseServicesEntity> stringStream = StreamController.broadcast();
    AppUtils.printLogs("Apply Body Datta ${seekerSearchSSEApi}transaction_id=$transactionId");

    // Start a timer to enforce the timeout
    final timer = Timer(timeout, () {
      stringStream.addError(ExceptionErrors.checkTimeOut.stringToString);
      stringStream.close();
      //throw TimeoutException('Connection timed out after $timeout');
    });

    try {
      SSEClient.unsubscribeFromSSE();
      //GET REQUEST
      SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: "${seekerSearchSSEApi}transaction_id=$transactionId",
          header: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen(
        (event) {
          AppUtils.printLogs('Data: ${event.data!}');

          try {
            // Parse JSON string into Map
            var response = json.decode(event.data!);

            if (response['success'] != null && response['success']) {
              SseServicesEntity model;
              model = SseServicesEntity.fromJson(json.decode(event.data!));
              stringStream.add(model);
            } else {
              SseServicesEntity model;
              model = SseServicesEntity.fromJson(json.decode(event.data!));
              stringStream.add(model);
              timer.cancel();
            }
          } catch (e) {
            AppUtils.printLogs('SSE Error: $e');
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
    } on TimeoutException {
      // Handle the timeout
      stringStream.addError(ExceptionErrors.checkTimeOut.stringToString);
      stringStream.close();
    } catch (e) {
      log(e.toString());

      stringStream.addError(e.toString());
      stringStream.close();
    }

    return stringStream.stream;
  }
}
