import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/exception_errors.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../domain/entities/add_document_to_wallet_entity.dart';
import '../../domain/entities/my_orders_entity.dart';
import '../../domain/entities/status_entity_model.dart';

/// My Orders API Service.
abstract class MyOrdersApiService {
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex);

  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex);

  Future<bool> rateOrder(String orderId, String rating, String feedback);

  Future<void> statusRequest(String body);

  Stream<StatusEntityModel> sseConnectionResponse(String transactionId, Duration timeout);

  Future<bool> uploadCertificateToWallet(AddDocumentToWalletEntity entity);

  Future<void> markAddToWallet(String orderId);
}

/// Implementation of [MyOrdersApiService] that interacts with the API service and manages network connectivity.
class MyOrdersApiServiceImpl implements MyOrdersApiService {
  MyOrdersApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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

  /// Fetches ongoing orders data from the API service.
  @override
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }
      AppUtils.printLogs("Orders token==>$authToken");
      AppUtils.printLogs("Orders token==>$myOrdersApi?page=$initialIndex&pageSize=$lastIndex");

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
      AppUtils.printLogs("Orders Progress Data----> Response ${response.data}");

      return MyOrdersListEntity.fromJson(response.data['data']);
    } catch (e) {
      AppUtils.printLogs("Orders Progress Data----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Fetches completed orders data from the API service.
  @override
  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }
      AppUtils.printLogs("Orders token==>$authToken");
      AppUtils.printLogs("Orders token==>$myOrdersApi?page=$initialIndex&pageSize=$lastIndex");

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
      AppUtils.printLogs("Orders Completed Data----> Response ${response.data}");

      return MyOrdersListEntity.fromJson(response.data['data']);
    } catch (e) {
      AppUtils.printLogs("Orders Completed Data----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Rates an order using provided order ID, rating, and feedback.
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
      AppUtils.printLogs("Rate order api token==>$authToken");
      AppUtils.printLogs("Rate orderId:$orderId ,ratings:$ratings, reviews:$review");

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
      AppUtils.printLogs("Rate order---->Response of Rate order  ${response.data}");

      return response.data != null ? response.data["success"] : false;
    } catch (e) {
      AppUtils.printLogs("Rate order----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Sends status request with provided body to check order status.
  @override
  Stream<StatusEntityModel> sseConnectionResponse(String transactionId, Duration timeout) {
    final StreamController<StatusEntityModel> stringStream = StreamController.broadcast();

    AppUtils.printLogs("Apply Body Datta $seekerSearchSSEApi/transaction_id=$transactionId");

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

  /// Sends status request with provided body to check order status.
  @override
  Future<void> statusRequest(String body) async {
    try {
      AppUtils.printLogs("Apply search entity ${body.toString()}");
      AppUtils.printLogs("Apply search entity $statusRequestApi");

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
      AppUtils.printLogs("Apply Search---->Response of seeker search  ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Apply search----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e).toString());
    }
  }

  @override
  Future<bool> uploadCertificateToWallet(
    AddDocumentToWalletEntity entity,
  ) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      var jsonData = json.encode(entity.toJson());
      AppUtils.printLogs("Add Document to Wallet token==>$authToken");
      AppUtils.printLogs("Add Document to Wallet request==>$jsonData");

      final response = await dio.post(
        addCertificateToWalletApi,
        data: jsonData,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Add Document to Wallet---->Response  ${response.data}");

      return response.data != null ? response.data["success"] : false;
    } catch (e) {
      AppUtils.printLogs("Mark Add Document to wallet----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  @override
  Future<void> markAddToWallet(
    String orderId,
  ) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Mark Add Document to wallet token==>$authToken");
      AppUtils.printLogs("Mark Add Document to wallet request==>$orderId");

      final response = await dio.patch(
        markAddToWalletApi,
        queryParameters: {
          'orderId': orderId,
        },
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Mark Add Document to wallet---->Response  ${response.data}");

      return response.data != null ? response.data["success"] : false;
    } catch (e) {
      AppUtils.printLogs("Mark Add Document to wallet----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }
}
