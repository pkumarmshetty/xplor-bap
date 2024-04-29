import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/domain/entities/update_consent_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_add_document_entity.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';
import 'package:xplor/features/wallet/domain/usecase/wallet_usecase.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late WalletUseCase walletUseCase;
  late MockWalletRepository mockRepository;

  setUp(() {
    mockRepository = MockWalletRepository();
    walletUseCase = WalletUseCase(repository: mockRepository);
  });

  group('WalletUseCase', () {
    test('getWalletId returns a String', () async {
      // Mock the behavior of the repository method
      when(mockRepository.getWalletData()).thenAnswer((_) async => 'wallet_id');

      // Call the method and expect a String result
      expect(await walletUseCase.getWalletId(), 'wallet_id');
    });

    test('getWalletVcData returns a List<DocumentVcData>', () async {
      // Mock the behavior of the repository method
      final List<DocumentVcData> vcList = [];
      when(mockRepository.getWalletVcList()).thenAnswer((_) async => vcList);

      // Call the method and expect a List<DocumentVcData> result
      expect(await walletUseCase.getWalletVcData(), vcList);
    });

    test('sharedWalletVcData completes without errors', () async {
      // Mock the behavior of the repository method
      final vcIds = ['vc1', 'vc2'];
      const request = 'test_request';
      when(mockRepository.sharedWalletVcData(vcIds, request)).thenAnswer((_) async {});

      // Call the method and expect it to complete without errors
      await expectLater(walletUseCase.sharedWalletVcData(vcIds, request), completes);
    });

    test('deletedDocVcList completes without errors', () async {
      // Mock the behavior of the repository method
      final vcIds = ['vc1', 'vc2'];
      when(mockRepository.deletedDocVcData(vcIds)).thenAnswer((_) async {});

      // Call the method and expect it to complete without errors
      await expectLater(walletUseCase.deletedDocVcList(vcIds), completes);
    });

    test('getMyConsents returns a List<SharedDataEntity>', () async {
      // Mock the behavior of the repository method
      final List<SharedVcDataEntity> consents = [];
      when(mockRepository.getMyConsents()).thenAnswer((_) async => consents);

      // Call the method and expect a List<SharedDataEntity> result
      expect(await walletUseCase.getMyConsents(), consents);
    });

    test('updateConsent returns true', () async {
      // Mock the behavior of the repository method
      final entity = UpdateConsentEntity(
        remarks: 'Remarks',
        restrictions: ConsentRestrictions(expiresIn: 3, viewOnce: false),
      );
      const requestId = 'test_request_id';
      when(mockRepository.updateConsent(entity, requestId)).thenAnswer((_) async => true);

      // Call the method and expect a true result
      expect(await walletUseCase.updateConsent(entity, requestId), true);
    });

    test('Should return true when repository returns true', () async {
      // Arrange
      when(mockRepository.verifyMpin('1234')).thenAnswer((_) async => true);

      // Act
      final result = await walletUseCase.verifyMpin('1234');

      // Assert
      expect(result, true);

      // Additional verification
      verify(mockRepository.verifyMpin('1234'));
    });

    test('Should return false when repository returns false', () async {
      // Arrange
      when(mockRepository.verifyMpin('4321')).thenAnswer((_) async => false);

      // Act
      final result = await walletUseCase.verifyMpin('4321');

      // Assert
      expect(result, false);

      // Additional verification
      verify(mockRepository.verifyMpin('4321'));
    });

    test('Should throw an exception when repository throws', () async {
      // Arrange
      when(mockRepository.verifyMpin('0000')).thenThrow(Exception('Failed to verify'));

      // Act & Assert
      expect(() async => await walletUseCase.verifyMpin('0000'), throwsException);

      // Additional verification
      verify(mockRepository.verifyMpin('0000'));
    });

    test('revokeConsent returns true', () async {
      // Mock the behavior of the repository method
      final entity = SharedVcDataEntity(
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
      when(mockRepository.revokeConsent(entity)).thenAnswer((_) async => true);

      // Call the method and expect a true result
      expect(await walletUseCase.revokeConsent(entity), true);
    });

    test('addDocumentWallet completes without errors', () async {
      // Mock the behavior of the repository method
      final params = WalletAddDocumentEntity();
      when(mockRepository.addDocumentWallet(params)).thenAnswer((_) async {});

      // Call the method and expect it to complete without errors
      await expectLater(walletUseCase.addDocumentWallet(params), completes);
    });
  });
}
