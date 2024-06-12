import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/api_constants.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../core/exception_errors.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../domain/entities/get_response_entity/services_entity.dart';
import '../../domain/entities/post_request_entity/search_post_entity.dart';

abstract class SeekerHomeApiService {
  Future<ServicesSearchEntity> search(SearchPostEntity body);
}

class SeekerHomeApiServiceImpl implements SeekerHomeApiService {
  SeekerHomeApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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
  Future<ServicesSearchEntity> search(SearchPostEntity entity, {int initialIndex = 0, int lastIndex = 10}) async {
    try {
      if (kDebugMode) {
        print("Seeker search entity ${entity.toJson()}");
        print("Seeker search entity $seekerSearchApi");
        print("Seeker search initialIndex ${entity.initialIndex}");
        print("Seeker search lastIndex ${entity.lastIndex}");
      }

      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      debugPrint("Search call token.... $authToken");
      final response = await dio.post(
        seekerSearchApi,
        data: entity.toJson(),
        queryParameters: {
          'page': entity.initialIndex,
          'pageSize': entity.lastIndex,
          // Add your query parameters here
        },
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": authToken,
          },
        ),
      );
      if (kDebugMode) {
        print("Seeker Search---->Response of seeker search  ${response.data}");
      }

      return ServicesSearchEntity.fromJson(response.data);
    } catch (e) {
      if (kDebugMode) {
        print("Seeker search----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  /* Future<SeekerSearchEntity> searchResponse(String transactionId) async {
    if (kDebugMode) {
      print("Seeker sse api call ---->");
    }
    */ /* SSEService(
        url: seekerSearchSSEApi,
        onDataReceived: (data) => debugPrint('SSE data: ${data.toString()}'),
        onError: (error) => debugPrint('SSE Error: ${error.toString()}'));
*/ /*
    try {
      Response response = await dio.get(
        seekerSearchSSEApi,
        options: Options(responseType: ResponseType.stream),
        //cancelToken: _cancelToken,
      );

      response.data!.stream
          .transform(utf8.decoder)
          .transform(json.decoder)
          .listen((event) {
        // Handle event data
        print("saffasfas ${event}");
        return event;
      }, onError: (error) {
        // Handle connection error
        throw Exception(handleError(error));
      });
    } catch (e) {
      // Handle Dio error
      throw Exception(handleError(e));
    }
  }*/

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

/* @override
  Stream<CatalogDataEntity> searchResponse(String transactionId) {
    final StreamController<CatalogDataEntity> stringStream =
        StreamController.broadcast();

    if (kDebugMode) {
      print(
          "OnBoarding Body Datta $seekerSearchSSEApi/transaction_id=$transactionId");
    }
    try {
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

          // Parse JSON string into Map
          var response = json.decode(event.data!);

          if (response['success'] != null && response['success']) {
          } else {
            CatalogDataEntity model;
            model = CatalogDataEntity.fromJson(json.decode(event.data!));
            stringStream.add(model);
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
    } catch (e) {
      log(e.toString());
      log("Exception  ${e.toString()}");
    }
    return stringStream.stream;
  }*/

/* dio
          .get(
        "${seekerSearchSSEApi}transaction_id=$transactionId",

        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            // Add any additional headers as needed
          },

          receiveTimeout: Duration(minutes: 10),
        ),
      )
          .then(
        (value) async {
          print("value   4{value fsdsf ${value}");

          await for (var dat in value.data.stream) {

            Uint8List uint8List = Uint8List.fromList(dat);
            String result = utf8.decode(uint8List);

            print("\n");
            //log("value   4{value fsdsf ${result}");
            debugPrint("value   4{value fsdsf ${result}");
            print("\n");

            // Parse JSON string into Map
            Map<String, dynamic> jsonMap =
                json.decode(result.replaceAll("data:", ""));

            if (jsonMap['success']!=null&&jsonMap['success']) {
            } else {
              print("value   4{value SeekerSearchEntity ${result}");
              CatalogDataEntity model;
              model=CatalogDataEntity.fromJson(jsonMap);

              stringStream.add(model);
            }
          }
        },
      ).onError(
        (DioException error, stackTrace) {
          log("Exception  ${error.message.toString()}");
          //stringStream.add(userDataError);
        },
      );
    } on DioException catch (e) {
      log(e.error.toString());
      log("Exception  ${e.error.toString()}");
    }
    return stringStream.stream;
  }*/
}
