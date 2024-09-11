import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/data/repositories/wallet_repository_impl.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/domain/entities/update_consent_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_add_document_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WalletRepositoryImpl repository;
  late MockWalletApiService mockApiService;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockApiService = MockWalletApiService();
    mockNetworkInfo = MockNetworkInfo();
    repository = WalletRepositoryImpl(apiService: mockApiService, networkInfo: mockNetworkInfo);
  });

  DocumentVcResponse documentVc = DocumentVcResponse.fromJson(
      json.decode(readJson('features/wallet_test/helpers/json_responses/get_doc_vc_data.json')));

  final sharedEntity = SharedVcDataEntity(
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

  group('getWalletData', () {
    test('should return wallet ID when network is available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.getWalletId()).thenAnswer((_) async => 'wallet_id');

      // Act
      final result = await repository.getWalletData();

      // Assert
      expect(result, 'wallet_id');
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.getWalletData();

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('getWalletVcList', () {
    test('should return list of wallet VC data when network is available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.getWalletVcData()).thenAnswer((_) async => documentVc.data);

      // Act
      final result = await repository.getWalletVcList();

      // Assert
      expect(result, documentVc.data);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.getWalletVcList();

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('addDocumentWallet', () {
    test('should add document to wallet when network is available', () async {
      // Arrange
      final entity = WalletAddDocumentEntity();
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      await repository.addDocumentWallet(entity);

      // Assert
      verify(mockApiService.addDocumentWallet(entity)).called(1);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      final entity = WalletAddDocumentEntity();
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.addDocumentWallet(entity);

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('sharedWalletVcData', () {
    test('should share wallet VC data when network is available', () async {
      // Arrange
      final vcIds = ['1', '2'];
      const request = 'Test request';
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      await repository.sharedWalletVcData(vcIds, request);

      // Assert
      verify(mockApiService.sharedVcId(vcIds, request)).called(1);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      final vcIds = ['1', '2'];
      const request = 'Test request';
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.sharedWalletVcData(vcIds, request);

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('deletedDocVcData', () {
    test('should delete wallet VC data when network is available', () async {
      // Arrange
      final vcIds = ['1', '2'];
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      await repository.deletedDocVcData(vcIds);

      // Assert
      verify(mockApiService.deletedVcIds(vcIds)).called(1);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      final vcIds = ['1', '2'];
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.deletedDocVcData(vcIds);

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('getMyConsents', () {
    test('should return list of shared data entities when network is available', () async {
      // Arrange
      final mockData = [sharedEntity];
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.getMyConsents()).thenAnswer((_) async => mockData);

      // Act
      final result = await repository.getMyConsents();

      // Assert
      expect(result, mockData);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.getMyConsents();

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('updateConsent', () {
    test('should update consent when network is available', () async {
      // Arrange
      final entity = UpdateConsentEntity(
          sharedWithEntity: 'Self Shared',
          remarks: 'Test remarks',
          restrictions: ConsentRestrictions(expiresIn: 3600, viewOnce: false));
      const requestId = 'request_id';
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.updateConsent(any, requestId)).thenAnswer((_) async => true);

      // Act
      final result = await repository.updateConsent(entity, requestId);

      // Assert
      expect(result, true);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      final entity = UpdateConsentEntity(
          sharedWithEntity: 'Self Shared',
          remarks: 'Test remarks',
          restrictions: ConsentRestrictions(expiresIn: 3600, viewOnce: false));
      const requestId = '123';
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.updateConsent(entity, requestId);

      // Assert
      await expectLater(call, throwsException);
    });
  });

  group('verifyMpin', () {
    test('Should return true when network is connected and API service returns true', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.verifyMpin('1234')).thenAnswer((_) async => true);

      // Act
      final result = await repository.verifyMpin('1234');

      // Assert
      expect(result, true);

      // Additional verification
      verify(mockNetworkInfo.isConnected);
      verify(mockApiService.verifyMpin('1234'));
    });

    test('Should throw an exception when network is not connected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act & Assert
      expect(() async => await repository.verifyMpin('1234'), throwsException);

      // Additional verification
      verify(mockNetworkInfo.isConnected);
      verifyNever(mockApiService.verifyMpin(any));
    });

    test('Should throw an exception when API service throws', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.verifyMpin('0000')).thenThrow(Exception('Failed to verify'));

      // Act & Assert
      expect(() async => await repository.verifyMpin('0000'), throwsException);
    });
  });

  group('revokeConsent', () {
    test('should revoke consent when network is available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockApiService.revokeConsent(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.revokeConsent(sharedEntity);

      // Assert
      expect(result, true);
    });

    test('should throw an exception when network is unavailable', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final call = repository.revokeConsent(sharedEntity);

      // Assert
      await expectLater(call, throwsException);
    });
  });
}
