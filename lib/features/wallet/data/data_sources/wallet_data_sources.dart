import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../domain/entities/previous_consent_entity.dart';
import '../../domain/entities/shared_data_entity.dart';
import '../../domain/entities/update_consent_entity.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../../../core/connection/refresh_token_service.dart';
import '../../domain/entities/wallet_add_document_entity.dart';
import '../../domain/entities/wallet_vc_list_entity.dart';

/// Abstract class for wallet api service.
abstract class WalletApiService {
  Future<String> getWalletId();

  Future<void> addDocumentWallet(WalletAddDocumentEntity entity);

  Future<List<DocumentVcData>> getWalletVcData();

  Future<void> sharedVcId(List<String> vcIds, String request);

  Future<void> deletedVcIds(
    List<String> vcIds,
  );

  Future<List<SharedVcDataEntity>> getMyConsents();

  Future<List<PreviousConsentEntity>> getMyPrevConsents();

  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId);

  Future<bool> revokeConsent(SharedVcDataEntity entity);

  Future<bool> verifyMpin(String pin);
}

/// Implementation class for wallet api service.
class WalletApiServiceImpl implements WalletApiService {
  WalletApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper}) {
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

  /// Method to get wallet id.
  @override
  Future<String> getWalletId() async {
    try {
      AppUtils.printLogs("Wallet Base Url ==>$getWalletApi");
      String? authToken;
      String? userId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        userId = preferencesHelper.getString(PrefConstKeys.userId);
      }
      AppUtils.printLogs("Wallet Base Url ==>$getWalletApi?userId=$userId");
      AppUtils.printLogs("Wallet Base Url ==>$getWalletApi?token=$authToken");
      final response = await dio.get(
        "$getWalletApi?userId=$userId",
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Wallet----> Response ${response.data}");
      if (helper != null) {
        await helper!.setString(PrefConstKeys.walletId, response.data["data"]["_id"]);
      } else {
        await preferencesHelper.setString(PrefConstKeys.walletId, response.data["data"]["_id"]);
      }

      return response.data != null ? response.data["data"]["_id"] : "";
    } catch (e) {
      if (helper != null) {
        await helper!.setString(PrefConstKeys.walletId, "");
      } else {
        await preferencesHelper.setString(PrefConstKeys.walletId, "");
      }
      AppUtils.printLogs("Wallet----> Catch ${AppUtils.handleError(e)}");
      return "";
    }
  }

  /// Method to add document to wallet.
  @override
  Future<List<DocumentVcData>> getWalletVcData() async {
    try {
      String? authToken;
      String? walletId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      AppUtils.printLogs("Wallet Base Url ==>$getWalletVcApi$walletId");
      final response = await dio.get(
        "$getWalletVcApi$walletId",
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Wallet----> Response ${response.data}");

      DocumentVcResponse vcWallet = DocumentVcResponse.fromJson(response.data);

      return vcWallet.data;
    } catch (e) {
      AppUtils.printLogs("Wallet----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to share wallet vc data.
  @override
  Future<String> sharedVcId(List<String> vcIds, String request) async {
    try {
      String? authToken;
      String? walletId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

// Construct the full URL with query parameters
      String urlWithParams = '$sharedWalletVcApi?walletId=$walletId&${_buildVcIdsQuery(vcIds)}';

      AppUtils.printLogs("Wallet Base Url ==>$urlWithParams");
      AppUtils.printLogs('urlWithParams $urlWithParams');
      AppUtils.printLogs('share wallet request $request');
      final response = await dio.put(
        urlWithParams,
        data: request,
        //queryParameters: queryParams,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Wallet----> Response ${response.data}");

      String restrictedUrl = "";
      var res = response.data["data"];
      for (int i = 0; i < res.length; i++) {
        restrictedUrl = restrictedUrl.isNotEmpty
            ? "$restrictedUrl,\n ${res[i]['vcDetails']['name']}: ${res[i]['restrictedUrl']}"
            : "${res[i]['vcDetails']['name']}: ${res[i]['restrictedUrl']}";
      }

      AppUtils.printLogs('test......$restrictedUrl');

      if (helper != null) {
        await helper!.setString(PrefConstKeys.sharedId, restrictedUrl);
      } else {
        await preferencesHelper.setString(PrefConstKeys.sharedId, restrictedUrl);
      }

      return restrictedUrl;
    } catch (e) {
      AppUtils.printLogs("Wallet----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to delete wallet vc data.
  @override
  Future<void> deletedVcIds(
    List<String> vcIds,
  ) async {
    try {
      String? authToken;
      String? walletId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }
      // Construct query parameters
      Map<String, dynamic> queryParams = {
        'walletId': walletId,
        for (int i = 0; i < vcIds.length; i++) 'vcIds[$i]': vcIds[i],
      };

      AppUtils.printLogs("Wallet Base Url ==>$deletedWalletVcApi");
      AppUtils.printLogs("Wallet Base Url ==>$queryParams");
      final response = await dio.delete(
        deletedWalletVcApi,
        queryParameters: queryParams,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      AppUtils.printLogs("Wallet----> Response ${response.data}");
    } catch (e) {
      AppUtils.printLogs("Wallet----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to get my consents.
  @override
  Future<List<SharedVcDataEntity>> getMyConsents() async {
    try {
      AppUtils.printLogs("Wallet Base Url ==>$getWalletApi");
      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      final Map<String, dynamic> queryParams = {
        'walletId': walletId,
        'status': 'ACCEPTED',
      };

      // Construct the URL with query parameters
      final Uri url = Uri.parse(getMyConsentsApi).replace(queryParameters: queryParams);
      final response = await dio.get(
        url.toString(),
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );

      List<dynamic> data = response.data['data'];
      List<SharedVcDataEntity> sharedDataEntity = data.map((json) => SharedVcDataEntity.fromJson(json)).toList();
      return sharedDataEntity;
    } catch (e) {
      AppUtils.printLogs("getMyConsents----> Catch $e");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to get my previous consents.
  @override
  Future<List<PreviousConsentEntity>> getMyPrevConsents() async {
    try {
      AppUtils.printLogs("Wallet Base Url ==>$getWalletApi");
      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      final Map<String, dynamic> queryParams = {
        'walletId': walletId,
        'status': 'EXPIRED',
      };

      // Construct the URL with query parameters
      final Uri url = Uri.parse(getMyConsentsApi).replace(queryParameters: queryParams);
      final response = await dio.get(
        url.toString(),
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );

      List<dynamic> data = response.data['data'];
      List<PreviousConsentEntity> sharedDataEntity = data.map((json) => PreviousConsentEntity.fromJson(json)).toList();
      return sharedDataEntity;
    } catch (e) {
      AppUtils.printLogs("getMyConsents----> Catch $e");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to update consent.
  @override
  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId) async {
    try {
      var jsonData = json.encode(entity.toJson());

      AppUtils.printLogs("updateConsentWallet Body Data $jsonData");

      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      final Map<String, dynamic> queryParams = {
        'walletId': walletId,
        'requestId': requestId,
      };

      AppUtils.printLogs(queryParams.toString());

      // Construct the URL with query parameters
      final Uri url = Uri.parse(updateConsentApi).replace(queryParameters: queryParams);

      await dio.patch(
        url.toString(),
        data: jsonData,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );

      return true;
    } catch (e) {
      AppUtils.printLogs("assignRoleOnBoarding----> Catch ${AppUtils.handleError(e)}");
      //return false;
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to revoke consent.
  @override
  Future<bool> revokeConsent(SharedVcDataEntity entity) async {
    try {
      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      final Map<String, dynamic> queryParams = {
        'walletId': walletId,
        'requestId': entity.id,
        'vcId': entity.vcId,
        'action': 'REJECTED',
      };

      AppUtils.printLogs(queryParams.toString());

      // Construct the URL with query parameters
      final Uri url = Uri.parse(revokeConsentApi).replace(queryParameters: queryParams);

      await dio.patch(
        url.toString(),
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      return true;
    } catch (e) {
      AppUtils.printLogs("assignRoleOnBoarding----> Catch ${AppUtils.handleError(e)}");
      //return false;
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to add document to wallet.
  @override
  Future<void> addDocumentWallet(WalletAddDocumentEntity entity) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.accessToken);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
      }

      String getMimeType(String filename) {
        // Use the lookupMimeType function from the mime package
        String? mimeType = lookupMimeType(filename);
        // Return the MIME type or a default value if it's null
        return mimeType ?? 'application/octet-stream';
      }

      String mimeType = getMimeType(entity.file!.path);

      if (helper != null) {
        await helper!.setString(PrefConstKeys.filePath, entity.file!.path);
      } else {
        await preferencesHelper.setString(PrefConstKeys.filePath, entity.file!.path);
      }

      final formData = FormData.fromMap({
        'walletId': entity.walletId,
        'category': entity.category,
        'name': entity.name,
        'file': await MultipartFile.fromFile(
          entity.file!.path,
          contentType: MediaType.parse(mimeType),
        ),
        'iconUrl': entity.iconUrl,
      });
      entity.tags?.asMap().forEach((index, value) {
        formData.fields.add(MapEntry('tags[$index]', value));
      });

      AppUtils.printLogs("addDocumentWallet----> Form Data ${formData.fields}");

      final response = await dio.post(
        addDocumentApi,
        data: formData,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": authToken,
          },
        ),
      );

      AppUtils.printLogs("addDocumentWallet----> Success 200 not found  ${response.statusCode}");
    } catch (e) {
      AppUtils.printLogs("addDocumentWallet----> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to verify mpin.
  @override
  Future<bool> verifyMpin(String pin) async {
    final authToken = helper == null
        ? preferencesHelper.getString(PrefConstKeys.accessToken)
        : helper!.getString(PrefConstKeys.accessToken);
    try {
      Map<String, dynamic> data = {
        'mPin': pin.toString(),
      };
      String jsonData = json.encode(data);

      AppUtils.printLogs("verifyMpin api: $jsonData");
      AppUtils.printLogs("verifyMpin api: $verifyMpinApi");

      final response = await dio.put(
        verifyMpinApi,
        data: jsonData,
        options: Options(
          headers: {
            "Authorization": authToken,
          },
          contentType: Headers.jsonContentType,
        ),
      );
      AppUtils.printLogs("Verify mPin success ${response.data["data"]}");

      return true;
    } catch (e) {
      AppUtils.printLogs("Verify MPin failed---> Catch ${AppUtils.handleError(e)}");
      throw Exception(AppUtils.handleError(e));
    }
  }

  /// Method to build vc ids query.
  String _buildVcIdsQuery(List<String> vcIds) {
    String query = '';
    for (int i = 0; i < vcIds.length; i++) {
      query += 'vcIds[$i]=${vcIds[i]}';
      if (i < vcIds.length - 1) {
        query += '&';
      }
    }
    return query;
  }
}
