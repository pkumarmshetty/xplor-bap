import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/exception_errors.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../domain/entities/my_orders_entity.dart';
import '../../domain/entities/status_entity_model.dart';

abstract class MyOrdersApiService {
  Future<MyOrdersListEntity> getOngoingOrdersData(
      String initialIndex, String lastIndex);

  Future<MyOrdersListEntity> getCompletedOrdersData(
      String initialIndex, String lastIndex);

  Future<bool> rateOrder(String orderId, String rating, String feedback);

  Future<void> statusRequest(String body);

  Stream<StatusEntityModel> sseConnectionResponse(
      String transactionId, Duration timeout);
}

class MyOrdersApiServiceImpl implements MyOrdersApiService {
  MyOrdersApiServiceImpl(
      {required this.dio, required this.preferencesHelper, this.helper}) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        handler.next(options);
      },
      onError: (DioException dioException,
          ErrorInterceptorHandler errorInterceptorHandler) async {
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
  Future<MyOrdersListEntity> getOngoingOrdersData(
      String initialIndex, String lastIndex) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }
      if (kDebugMode) {
        print("Orders token==>$authToken");
        print(
            "Orders token==>$myOrdersApi?page=$initialIndex&pageSize=$lastIndex");
      }

      final response = await dio.get(
        myOrdersApi,
        queryParameters: {
          'page': initialIndex,
          'pageSize': lastIndex,
          'status': "TILL_IN_PROGRESS",
          // Add your query parameters here
        },
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Orders Progress Data----> Response ${response.data}");
      }

      return MyOrdersListEntity.fromJson(response.data['data']);
    } catch (e) {
      if (kDebugMode) {
        print("Orders Progress Data----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<MyOrdersListEntity> getCompletedOrdersData(
      String initialIndex, String lastIndex) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }
      if (kDebugMode) {
        print("Orders token==>$authToken");
        print(
            "Orders token==>$myOrdersApi?page=$initialIndex&pageSize=$lastIndex");
      }

      final response = await dio.get(
        myOrdersApi,
        queryParameters: {
          'page': initialIndex,
          'pageSize': lastIndex,

          'status': "COMPLETED",
          // Add your query parameters here
        },
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Orders Completed Data----> Response ${response.data}");
      }

      return MyOrdersListEntity.fromJson(response.data['data']);
    } catch (e) {
      if (kDebugMode) {
        print("Orders Completed Data----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<bool> rateOrder(
    String orderId,
    String ratings,
    String review,
  ) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }
      if (kDebugMode) {
        print("Rate order api token==>$authToken");
        print("Rate orderId:$orderId ,ratings:$ratings, reviews:$review");
      }

      final Map<String, dynamic> data = {
        'rating': ratings,
        'review': review,
      };
      var jsonData = json.encode(data);
      var ratingsEndPoint = '$myOrdersApi/$orderId/rate';
      final response = await dio.patch(
        ratingsEndPoint,
        data: jsonData,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Rate order---->Response of Rate order  ${response.data}");
      }

      return response.data != null ? response.data["success"] : false;
    } catch (e) {
      if (kDebugMode) {
        print("Rate order----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Stream<StatusEntityModel> sseConnectionResponse(
      String transactionId, Duration timeout) {
    final StreamController<StatusEntityModel> stringStream =
        StreamController.broadcast();

    if (kDebugMode) {
      print(
          "Apply Body Datta $seekerSearchSSEApi/transaction_id=$transactionId");
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
              StatusEntityModel model;
              model = StatusEntityModel.fromJson(json.decode(event.data!));
              stringStream.add(model);
            } else {
              StatusEntityModel model;
              model = StatusEntityModel.fromJson(json.decode(event.data!));
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
    } on TimeoutException catch (_) {
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

  @override
  Future<void> statusRequest(String body) async {
    try {
      if (kDebugMode) {
        print("Apply search entity ${body.toString()}");
        print("Apply search entity $statusRequestApi");
      }

      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      final response = await dio.post(
        statusRequestApi,
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
      throw Exception(handleError(e).toString());
    }
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
          errorDescription =
              ExceptionErrors.connectionTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription =
              ExceptionErrors.unknownConnectionError.stringToString;

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = ExceptionErrors.receiveTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print(
                "${ExceptionErrors.badResponseError}  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = ExceptionErrors.sendTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = ExceptionErrors.badCertificate.stringToString;

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription =
              ExceptionErrors.serverConnectingIssue.stringToString;

          return errorDescription;
      }
    } else {
      errorDescription = ExceptionErrors.unexpectedErrorOccurred.stringToString;
      return errorDescription;
    }
  }
}
