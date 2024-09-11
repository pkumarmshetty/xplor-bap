import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api_constants.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../domain/entities/get_response_entity/services_entity.dart';
import '../../domain/entities/post_request_entity/search_post_entity.dart';

/// Seeker home api service
abstract class SeekerHomeApiService {
  Future<ServicesSearchEntity> search(SearchPostEntity body);
}

/// Seeker home api service implementation
class SeekerHomeApiServiceImpl implements SeekerHomeApiService {
  SeekerHomeApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
    // Add refresh token interceptor
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

  /// Search api call
  @override
  Future<ServicesSearchEntity> search(SearchPostEntity entity, {int initialIndex = 0, int lastIndex = 10}) async {
    try {
      AppUtils.printLogs("Seeker search entity ${entity.toJson()}");
      AppUtils.printLogs("Seeker search entity $seekerSearchApi");
      AppUtils.printLogs("Seeker search initialIndex ${entity.initialIndex}");
      AppUtils.printLogs("Seeker search lastIndex ${entity.lastIndex}");

      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      AppUtils.printLogs("Search call token.... $authToken");
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
      AppUtils.printLogs("Seeker Search---->Response of seeker search  ${response.data}");

      return ServicesSearchEntity.fromJson(response.data);
    } catch (e) {
      AppUtils.printLogs("Seeker search----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /* Future<SeekerSearchEntity> searchResponse(String transactionId) async {
      AppUtils.printLogs("Seeker sse api call ---->");

    */ /* SSEService(
        url: seekerSearchSSEApi,
        onDataReceived: (data) => AppUtils.printLogs('SSE data: ${data.toString()}'),
        onError: (error) => AppUtils.printLogs('SSE Error: ${error.toString()}'));
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
        AppUtils.printLogs("saffasfas ${event}");
        return event;
      }, onError: (error) {
        // Handle connection error
        throw Exception(AppUtils.handleError(error));
      });
    } catch (e) {
      // Handle Dio error
      throw Exception(AppUtils.handleError(e));
    }
  }*/

/* @override
  Stream<CatalogDataEntity> searchResponse(String transactionId) {
    final StreamController<CatalogDataEntity> stringStream =
        StreamController.broadcast();

      AppUtils.printLogs(
          "OnBoarding Body Datta $seekerSearchSSEApi/transaction_id=$transactionId");

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
          AppUtils.printLogs('Data: ${event.data!}');

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
            AppUtils.printLogs('SSE Error: $error');

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
          AppUtils.printLogs("value   4{value fsdsf ${value}");

          await for (var dat in value.data.stream) {

            Uint8List uint8List = Uint8List.fromList(dat);
            String result = utf8.decode(uint8List);

            AppUtils.printLogs("\n");
            //log("value   4{value fsdsf ${result}");
            AppUtils.printLogs("value   4{value fsdsf ${result}");
            AppUtils.printLogs("\n");

            // Parse JSON string into Map
            Map<String, dynamic> jsonMap =
                json.decode(result.replaceAll("data:", ""));

            if (jsonMap['success']!=null&&jsonMap['success']) {
            } else {
              AppUtils.printLogs("value   4{value SeekerSearchEntity ${result}");
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
