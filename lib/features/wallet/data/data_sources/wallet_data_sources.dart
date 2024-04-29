import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/core/exception_errors.dart';
import 'package:xplor/features/wallet/domain/entities/previous_consent_entity.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/domain/entities/update_consent_entity.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/api_constants.dart';
import '../../domain/entities/wallet_add_document_entity.dart';
import '../../domain/entities/wallet_vc_list_entity.dart';

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

class WalletApiServiceImpl implements WalletApiService {
  WalletApiServiceImpl({required this.dio, required this.preferencesHelper, this.helper});

  Dio dio;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  @override
  Future<String> getWalletId() async {
    try {
      if (kDebugMode) {
        print("Wallet Base Url ==>$getWalletApi");
      }
      String? authToken;
      String? userId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
        userId = preferencesHelper.getString(PrefConstKeys.userId);
      }
      if (kDebugMode) {
        print("Wallet Base Url ==>$getWalletApi?userId=$userId");
        print("Wallet Base Url ==>$getWalletApi?token=$authToken");
      }
      final response = await dio.get(
        "$getWalletApi?userId=$userId",
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Wallet----> Response ${response.data}");
      }
      if (helper != null) {
        await helper!.setString(PrefConstKeys.walletId, response.data["data"]["_id"]);
      } else {
        await preferencesHelper.setString(PrefConstKeys.walletId, response.data["data"]["_id"]);
      }

      return response.data != null ? response.data["data"]["_id"] : "";
    } catch (e) {
      if (kDebugMode) {
        print("Wallet----> Catch ${handleError(e)}");
      }
      return "";
    }
  }

  @override
  Future<List<DocumentVcData>> getWalletVcData() async {
    try {
      String? authToken;
      String? walletId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      if (kDebugMode) {
        print("Wallet Base Url ==>$getWalletVcApi$walletId");
      }
      final response = await dio.get(
        "$getWalletVcApi$walletId",
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Wallet----> Response ${response.data}");
      }

      DocumentVcResponse vcWallet = DocumentVcResponse.fromJson(response.data);

      return vcWallet.data;
    } catch (e) {
      if (kDebugMode) {
        print("Wallet----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<String> sharedVcId(List<String> vcIds, String request) async {
    try {
      String? authToken;
      String? walletId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

// Construct the full URL with query parameters
      String urlWithParams = '$sharedWalletVcApi?walletId=$walletId&${_buildVcIdsQuery(vcIds)}';

      if (kDebugMode) {
        print("Wallet Base Url ==>$urlWithParams");
      }
      final response = await dio.put(
        urlWithParams,
        data: request,
        //queryParameters: queryParams,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Wallet----> Response ${response.data}");
      }

      String restrictedUrl = "";
      var res = response.data["data"];
      for (int i = 0; i < res.length; i++) {
        restrictedUrl = restrictedUrl.isNotEmpty
            ? "$restrictedUrl,\n ${res[i]['vcDetails']['name']}: ${res[i]['restrictedUrl']}"
            : "${res[i]['vcDetails']['name']}: ${res[i]['restrictedUrl']}";
      }

      if (kDebugMode) {
        print('test......$restrictedUrl');
      }

      if (helper != null) {
        await helper!.setString(PrefConstKeys.sharedId, restrictedUrl);
      } else {
        await preferencesHelper.setString(PrefConstKeys.sharedId, restrictedUrl);
      }

      return restrictedUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Wallet----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<void> deletedVcIds(
    List<String> vcIds,
  ) async {
    try {
      String? authToken;
      String? walletId = "";

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }
      // Construct query parameters
      Map<String, dynamic> queryParams = {
        'walletId': walletId,
        for (int i = 0; i < vcIds.length; i++) 'vcIds[$i]': vcIds[i],
      };

      if (kDebugMode) {
        print("Wallet Base Url ==>$deletedWalletVcApi");
        print("Wallet Base Url ==>$queryParams");
      }
      final response = await dio.delete(
        deletedWalletVcApi,
        queryParameters: queryParams,
        options: Options(contentType: Headers.jsonContentType, headers: {
          "Authorization": authToken,
        }),
      );
      if (kDebugMode) {
        print("Wallet----> Response ${response.data}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Wallet----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<List<SharedVcDataEntity>> getMyConsents() async {
    try {
      if (kDebugMode) {
        print("Wallet Base Url ==>$getWalletApi");
      }
      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
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
      if (kDebugMode) {
        print("getMyConsents----> Catch $e");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<List<PreviousConsentEntity>> getMyPrevConsents() async {
    try {
      if (kDebugMode) {
        print("Wallet Base Url ==>$getWalletApi");
      }
      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
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
      if (kDebugMode) {
        print("getMyConsents----> Catch $e");
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId) async {
    try {
      var jsonData = json.encode(entity.toJson());

      if (kDebugMode) {
        print("updateConsentWallet Body Data $jsonData");
      }

      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      final Map<String, dynamic> queryParams = {
        'walletId': walletId,
        'requestId': requestId,
      };

      if (kDebugMode) {
        print(queryParams);
      }

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
      if (kDebugMode) {
        print("assignRoleOnBoarding----> Catch ${handleError(e)}");
        return false;
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<bool> revokeConsent(SharedVcDataEntity entity) async {
    try {
      String? authToken;
      String? walletId;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
        walletId = helper!.getString(PrefConstKeys.walletId);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
        walletId = preferencesHelper.getString(PrefConstKeys.walletId);
      }

      final Map<String, dynamic> queryParams = {
        'walletId': walletId,
        'requestId': entity.id,
        'vcId': entity.vcId,
        'action': 'REJECTED',
      };

      if (kDebugMode) {
        print(queryParams);
      }

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
      if (kDebugMode) {
        print("assignRoleOnBoarding----> Catch ${handleError(e)}");
        return false;
      }
      throw Exception(handleError(e));
    }
  }

  @override
  Future<void> addDocumentWallet(WalletAddDocumentEntity entity) async {
    try {
      String? authToken;

      if (helper != null) {
        authToken = helper!.getString(PrefConstKeys.token);
      } else {
        authToken = preferencesHelper.getString(PrefConstKeys.token);
      }

      String getMimeType(String filename) {
        // Use the lookupMimeType function from the mime package
        String? mimeType = lookupMimeType(filename);
        // Return the MIME type or a default value if it's null
        return mimeType ?? 'application/octet-stream';
      }

      String mimeType = getMimeType(entity.file!.path);

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

      if (kDebugMode) {
        print("addDocumentWallet----> Form Data ${formData.fields}");
      }

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

      if (kDebugMode) {
        print("addDocumentWallet----> Success 200 not found  ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("addDocumentWallet----> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

  String handleError(Object error) {
    String errorDescription = "";

    if (error is DioException) {
      DioException dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = requestCancelError;

          return errorDescription;
        case DioExceptionType.connectionTimeout:
          errorDescription = connectionTimeOutError;

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription = unknownConnectionError;

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = receiveTimeOutError;

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print("$badResponseError  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = sendTimeOutError;

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = badCertificate;

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription = serverConnectingIssue;

          return errorDescription;
      }
    } else {
      errorDescription = unexpectedErrorOccurred;
      return errorDescription;
    }
  }

  @override
  Future<bool> verifyMpin(String pin) async {
    final authToken =
        helper == null ? preferencesHelper.getString(PrefConstKeys.token) : helper!.getString(PrefConstKeys.token);
    try {
      Map<String, dynamic> data = {
        'mPin': pin.toString(),
      };
      String jsonData = json.encode(data);

      if (kDebugMode) {
        print("verifyMpin api: $pin");
      }

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
      if (kDebugMode) {
        print("Verify mPin success ${response.data["data"]}");
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Verify MPin failed---> Catch ${handleError(e)}");
      }
      throw Exception(handleError(e));
    }
  }

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
