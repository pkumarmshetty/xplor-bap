import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/api_constants.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../core/exception_errors.dart';
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

      if (kDebugMode) {
        print("Home User Data token==>$authToken");
      }

      if (kDebugMode) {
        print("Apply search entity ${body.toString()}");
        print("Apply search entity $initRequestApi");
      }

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
      if (kDebugMode) {
        print("Apply Search---->Response of seeker search  ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Apply search----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<void> confirmRequest(String body) async {
    try {
      if (kDebugMode) {
        print("Apply search entity ${body.toString()}");
        print("Apply search entity $confirmRequestApi");
      }
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
      if (kDebugMode) {
        print("Apply Search---->Response of seeker search  ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Apply search----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<dynamic> selectRequest(String body) async {
    try {
      if (kDebugMode) {
        print("Apply select entity ${body.toString()}");
        print("Apply select entity $selectRequestApi");
      }

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

      if (kDebugMode) {
        print("Apply Search---->Response of seeker search  ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Apply search----> Catch ${handleError(e)}");
      }

      // return Future.error(handleError(handleError(e)));
      throw Exception(handleError(e));
    }
  }

  @override
  Stream<SseServicesEntity> sseConnectionResponse(String transactionId, Duration timeout) {
    final StreamController<SseServicesEntity> stringStream = StreamController.broadcast();

    if (kDebugMode) {
      print("Apply Body Datta $seekerSearchSSEApi/transaction_id=$transactionId");
    }

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
          debugPrint('Data: ${event.data!}');

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
            if (kDebugMode) {
              print('SSE Error: $e');
            }
            stringStream.addError(ExceptionErrors.checkTimeOut.stringToString);
            stringStream.close();
          }
        },
        onError: (error) {
          // Ensure the stream is closed on error
          if (kDebugMode) {
            print('SSE Error: $error');
          }
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
          errorDescription = ExceptionErrors.checkInternetConnection.stringToString;

          return errorDescription;
      }
    } else {
      errorDescription = ExceptionErrors.unexpectedErrorOccurred.stringToString;
      return errorDescription;
    }
  }
}
