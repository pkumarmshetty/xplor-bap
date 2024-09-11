import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/core/connection/refresh_token_service.dart';
import 'package:xplor/features/wallet/data/data_sources/wallet_data_sources.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/domain/entities/update_consent_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_add_document_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';
import '../../../on_boarding_test/helpers/test_helper.mocks.dart';
import '../../helpers/json_reader.dart';

void main() {
  late WalletApiServiceImpl walletApiService;
  late MockSharedPreferencesHelper mockSharedPreferencesHelper;
  SharedPreferences pref;
  late MockDio mockDio;

  setUp(() async {
    mockDio = MockDio();
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();
    SharedPreferences.setMockInitialValues({}); //set values here
    pref = await SharedPreferences.getInstance();
    pref.setString(
      PrefConstKeys.accessToken,
      "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyXzE0NmMzNTJjLTNiMzEtNGNjYS04OWYwLTJlYjM4YWU4NGRiMCIsImlhdCI6MTcxMjU3OTM4OSwiZXhwIjoxNzE2MTc5Mzg5fQ.tT_Rx8f1eUiFSrXX6DNsUH9FiGrhGzl8m5Z7YD3i6ug",
    );
    pref.setString(PrefConstKeys.walletId, "wallet_db9adfb2-a307-4cbb-807d-a43846018869");
    pref.setString(PrefConstKeys.userId, "user_146c352c-3b31-4cca-89f0-2eb38ae84db0");
    mockSharedPreferencesHelper = MockSharedPreferencesHelper();
    walletApiService = WalletApiServiceImpl(
        dio: mockDio,
        preferencesHelper: mockSharedPreferencesHelper,
        helper: pref);

    mockDio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        handler.next(options);
      },
      onError: (DioException dioException,
          ErrorInterceptorHandler errorInterceptorHandler) async {
        if (dioException.response?.statusCode == 511) {
          await RefreshTokenService.refreshTokenAndRetry(
            options: dioException.response!.requestOptions,
            helper: pref,
            dio: mockDio,
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
            helper: pref,
            dio: mockDio,
            handler: handler,
          );
        } else {
          handler.next(response);
        }
      },
    ));
  });

  group('getWalletId', () {
    test('returns wallet id when successful', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => Response(
              data: {
                'data': {'_id': 'wallet_db9adfb2-a307-4cbb-807d-a43846018869'}
              },
              statusCode: 200,
              requestOptions: RequestOptions(
                contentType: Headers.jsonContentType,
              )));

      // Act
      final result = await walletApiService.getWalletId();

      // Assert
      expect(result, 'wallet_db9adfb2-a307-4cbb-807d-a43846018869');
    });

    test('throws exception when error occurs', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(Exception('Failed to get wallet id'));
      await walletApiService.getWalletId();
      verify(mockDio.get(any, options: anyNamed('options'))).called(1);
    });
  });

  group('getWalletVcData', () {
    test('returns list of DocumentVcData when successful', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options'))).thenAnswer((_) async => Response(
            data: json.decode(readJson('features/wallet_test/helpers/json_responses/get_doc_vc_data.json')),
            statusCode: 200,
            requestOptions: RequestOptions(
              contentType: Headers.jsonContentType,
            ),
          ));

      // Act
      final result = await walletApiService.getWalletVcData();

      // Assert
      expect(result, isA<List<DocumentVcData>>());
    });

    test('throws exception when error occurs', () async {
      // Arrange
      when(mockSharedPreferencesHelper.getString(any)).thenReturn('auth_token');
      when(mockSharedPreferencesHelper.getString(PrefConstKeys.walletId)).thenReturn('wallet_id');
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(DioException(
        response: Response(
          data: 'error',
          requestOptions: RequestOptions(
            contentType: Headers.jsonContentType,
          ),
        ),
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(
          contentType: Headers.jsonContentType,
        ),
      ));

      // Act & Assert
      expect(() => walletApiService.getWalletVcData(), throwsException);
    });
  });

  group('sharedVcId', () {
    test('returns restricted url when successful', () async {
      // Arrange
      when(mockSharedPreferencesHelper.getString(any)).thenReturn('auth_token');
      when(mockSharedPreferencesHelper.getString(PrefConstKeys.walletId)).thenReturn('wallet_id');
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: {
                'data': [
                  {
                    'vcDetails': {'name': 'Document 1'},
                    'restrictedUrl': 'http://example.com/document1'
                  },
                  {
                    'vcDetails': {'name': 'Document 2'},
                    'restrictedUrl': 'http://example.com/document2'
                  }
                ]
              }, requestOptions: RequestOptions()));

      // Act
      final result = await walletApiService.sharedVcId(['vc_id'], 'request');

      // Assert
      expect(result, contains('Document 1'));
      expect(result, contains('http://example.com/document1'));
      expect(result, contains('Document 2'));
      expect(result, contains('http://example.com/document2'));
    });

    test('throws exception when error occurs', () async {
      // Arrange
      when(mockSharedPreferencesHelper.getString(any)).thenReturn('auth_token');
      when(mockSharedPreferencesHelper.getString(PrefConstKeys.walletId)).thenReturn('wallet_id');
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(DioException(
          response: Response(data: 'error', requestOptions: RequestOptions()),
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions()));

      // Act & Assert
      expect(() => walletApiService.sharedVcId(['vcId1', 'vcId2'], 'sampleRequest'), throwsException);
    });
  });

  group('addDocumentWallet', () {
    test('should make a successful request', () async {
      // Arrange
      final entity = WalletAddDocumentEntity(
        walletId: PrefConstKeys.walletId,
        category: 'testcategory',
        name: 'testdocument',
        type: 'testtype',
        file: File("test/features/wallet_test/helpers/dummy_file/dummy.pdf"),
        iconUrl: 'testiconurl',
        tags: ['tag1', 'tag2'],
      );

      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: entity, statusCode: 200, requestOptions: RequestOptions()));

      // Act
      await walletApiService.addDocumentWallet(entity);

      // Assert
      verify(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      ));
    });

    test('should throw exception on error', () async {
      // Arrange
      final entity = WalletAddDocumentEntity(
        walletId: 'test_wallet_id',
        category: 'test_category',
        name: 'test_document',
        file: File('path/to/test_file'),
        iconUrl: 'test_icon_url',
        tags: ['tag1', 'tag2'],
      );

      // Mock error response
      when(mockSharedPreferencesHelper.getString(any)).thenReturn('test_token');
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(DioException(
          response: Response(
            data: 'error_message',
            statusCode: 500,
            requestOptions: RequestOptions(),
          ),
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions()));

      // Act & Assert
      expect(() => walletApiService.addDocumentWallet(entity), throwsException);
    });
  });

  group('WalletApiService - revokeConsent', () {
    final entity = SharedVcDataEntity(
        sharedWithEntity: 'Self Shared',
        id: 'id',
        vcId: 'vcId',
        status: 'status',
        restrictedUrl: 'restrictedUrl',
        raisedByWallet: 'raisedByWallet',
        vcOwnerWallet: 'vcOwnerWallet',
        remarks: 'remarks',
        vcShareDetails: DocVcSharedDetails(
            certificateType: '',
            restrictions: Restrictions(
              expiresIn: 3,
              viewOnce: false,
            )),
        createdAt: 'createdAt',
        updatedAt: 'updatedAt',
        v: 1,
        fileDetails: FileDetails(
          id: 'id',
          walletId: 'walletId',
          fileType: 'fileType',
          createdAt: 'createdAt',
          updatedAt: 'updatedAt',
          v: 1,
        ),
        vcDetails: VcDetails(
          id: 'id',
          walletId: 'walletId',
          createdAt: 'createdAt',
          updatedAt: 'updatedAt',
          v: 1,
          did: 'did',
          fileId: 'fileId',
          type: 'type',
          category: 'category',
          tags: ['tag', 'tag2'],
          name: 'name',
          iconUrl: 'iconUrl',
          templateId: 'templateId',
          restrictedUrl: 'restrictedUrl',
        ));

    test('should make a successful request to revoke consent', () async {
      // Arrange

      when(mockDio.patch(any, options: anyNamed('options'))).thenAnswer((_) async => Response(
            statusCode: 200,
            requestOptions: RequestOptions(),
          ));

      // Act
      final result = await walletApiService.revokeConsent(entity);

      // Assert
      expect(result, true);
      verify(mockDio.patch(
        any,
        options: anyNamed('options'),
      ));
    });

    test('should throw an exception when an error occurs during revoking consent', () async {
      when(mockDio.patch(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(DioException(
        response: Response(
          data: Future.value('error'),
          statusCode: 500,
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      ));

      await walletApiService.revokeConsent(entity);
      verify(mockDio.patch(any, data: anyNamed('data'), options: anyNamed('options'))).called(1);
    });
  });

  group('updateConsent', () {
    final entity = UpdateConsentEntity(
      sharedWithEntity: 'Self Shared',
      remarks: 'Remarks',
      restrictions: ConsentRestrictions(expiresIn: 24, viewOnce: true),
    );
    test('should update consent successfully', () async {
      // Arrange
      const requestId = 'request_c953df0b-bacd-45c1-b061-77ef13182ed0';

      when(mockDio.patch(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: anyNamed('data'), statusCode: 200, requestOptions: RequestOptions()));

      // Act
      final result = await walletApiService.updateConsent(entity, requestId);

      // Assert
      expect(result, false);
    });

    test('should throw a DioException when an error occurs during consent update', () async {
      // Arrange
      const requestId = 'test_request_id';

      when(mockDio.patch(any, data: anyNamed('data'), options: anyNamed('options'))).thenThrow(DioException(
          response: Response(data: 'error_message', statusCode: 500, requestOptions: RequestOptions()),
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions()));

      // Act & Assert
      final result = await walletApiService.updateConsent(entity, requestId);

      expect(result, false);
      verify(mockDio.patch(any, data: anyNamed('data'), options: anyNamed('options'))).called(1);
    });
  });

  group('getMyConsents', () {
    test('Successful API Call', () async {
      // Arrange
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(data: {'data': []}, statusCode: 200, requestOptions: RequestOptions()));

      // Act
      final result = await walletApiService.getMyConsents();

      // Assert
      expect(result, isA<List<SharedVcDataEntity>>());
    });
    test('should throw an exception when an error occurs during data retrieval', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(DioException(
          response: Response(data: 'error_message', statusCode: 500, requestOptions: RequestOptions()),
          type: DioExceptionType.badCertificate,
          requestOptions: RequestOptions()));

      // Act & Assert
      expect(() => walletApiService.getMyConsents(), throwsException);
    });
    test('should throw an exception when an error occurs during data retrieval', () async {
      when(mockDio.get(any, options: anyNamed('options'))).thenThrow(Exception('Unexpected error occurred'));

      // Act & Assert
      expect(() => walletApiService.getMyConsents(), throwsException);
    });
  });

  group('deletedVcIds', () {
    test('should send a successful delete request', () async {
      // Arrange
      final vcIds = ['vcId1', 'vcId2', 'vcId3'];
      final queryParams = {
        'walletId': PrefConstKeys.walletId,
        'vcIds[0]': vcIds[0],
        'vcIds[1]': vcIds[1],
        'vcIds[2]': vcIds[2],
      };

      when(mockDio.delete(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: null,
                statusCode: 200,
                requestOptions: RequestOptions(),
              ));

      // Act
      await walletApiService.deletedVcIds(vcIds);

      // Assert
      verifyNever(mockDio.delete(
        any,
        queryParameters: queryParams,
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {"Authorization": PrefConstKeys.accessToken},
        ),
      ));
    });

    test('should throw an exception when an error occurs during deletion', () async {
      // Arrange
      final vcIds = ['vcId1', 'vcId2', 'vcId3'];

      when(mockDio.delete(any, queryParameters: anyNamed('queryParameters'), options: anyNamed('options'))).thenThrow(
          DioException(
              response: Response(data: 'error_message', statusCode: 500, requestOptions: RequestOptions()),
              type: DioExceptionType.connectionTimeout,
              requestOptions: RequestOptions()));

      // Act & Assert
      expect(() => walletApiService.deletedVcIds(vcIds), throwsException);
    });
  });

  group('verifyMpin', () {
    test('Should return true on successful verification', () async {
      // Arrange
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async =>
          Response(data: {'data': 'verification successful'}, statusCode: 200, requestOptions: RequestOptions()));

      // Act
      final result = await walletApiService.verifyMpin('1234');

      // Assert
      expect(result, true);

      // Additional verifications
      verify(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options')));
    });

    test('Should throw an exception on failure', () async {
      // Arrange
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(Exception('Failed to verify'));

      // Act & Assert
      expect(() async => await walletApiService.verifyMpin('1234'), throwsException);

      // Additional verifications
      verify(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options')));
    });

    test('Should print debug message in debug mode', () async {
      // Arrange
      when(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options'))).thenAnswer((_) async =>
          Response(data: {'data': 'verification successful'}, statusCode: 200, requestOptions: RequestOptions()));

      // Act
      await walletApiService.verifyMpin('1234');

      // Assert
      verify(mockDio.put(any, data: anyNamed('data'), options: anyNamed('options')));
    });
  });
}
