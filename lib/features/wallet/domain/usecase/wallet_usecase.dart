import '../entities/shared_data_entity.dart';
import '../entities/previous_consent_entity.dart';
import '../entities/update_consent_entity.dart';
import '../entities/wallet_add_document_entity.dart';
import '../entities/wallet_vc_list_entity.dart';
import '../repository/wallet_repository.dart';

/// Use case for wallet.
class WalletUseCase {
  WalletRepository repository;

  WalletUseCase({required this.repository});

  /// Method to get wallet id.
  Future<String> getWalletId() async {
    return await repository.getWalletData();
  }

  /// Method to add document to wallet.
  Future<List<DocumentVcData>> getWalletVcData() async {
    return await repository.getWalletVcList();
  }

  /// Method to share wallet vc data.
  Future<void> sharedWalletVcData(List<String> vcIds, String request) async {
    return await repository.sharedWalletVcData(vcIds, request);
  }

  /// Method to delete wallet vc data.
  Future<void> deletedDocVcList(List<String> vcIds) async {
    return await repository.deletedDocVcData(vcIds);
  }

  /// Method to get my consents.
  Future<List<SharedVcDataEntity>> getMyConsents() async {
    return await repository.getMyConsents();
  }

  /// Method to get my previous consents.
  Future<List<PreviousConsentEntity>> getMyPrevConsents() async {
    return await repository.getMyPrevConsents();
  }

  /// Method to update consent.
  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId) async {
    return await repository.updateConsent(entity, requestId);
  }

  /// Method to revoke consent.
  Future<bool> revokeConsent(SharedVcDataEntity entity) async {
    return await repository.revokeConsent(entity);
  }

  /// Method to verify mpin.
  Future<bool> verifyMpin(String pin) async {
    return await repository.verifyMpin(pin);
  }

  /// Method to add document to wallet.
  Future<void> addDocumentWallet(WalletAddDocumentEntity params) async {
    return await repository.addDocumentWallet(params);
  }
}
