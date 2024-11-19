import '../entities/wallet_add_document_entity.dart';
import '../entities/previous_consent_entity.dart';
import '../entities/wallet_vc_list_entity.dart';
import '../entities/shared_data_entity.dart';
import '../entities/update_consent_entity.dart';

/// Interface for wallet repository.
abstract class WalletRepository {
  /// Method to get wallet data.
  Future<String> getWalletData();

  /// Method to add document to wallet.
  Future<void> addDocumentWallet(WalletAddDocumentEntity? entity);

  /// Method to get wallet vc data.
  Future<List<DocumentVcData>> getWalletVcList();

  /// Method to share wallet vc data.
  Future<void> sharedWalletVcData(List<String> vcIds, String request);

  /// Method to delete wallet vc data.
  Future<void> deletedDocVcData(List<String> vcIds);

  /// Method to get my consents.
  Future<List<SharedVcDataEntity>> getMyConsents();

  /// Method to get my previous consents.
  Future<List<PreviousConsentEntity>> getMyPrevConsents();

  /// Method to update consent.
  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId);

  /// Method to revoke consent.
  Future<bool> revokeConsent(SharedVcDataEntity entity);

  /// Method to verify mpin.
  Future<bool> verifyMpin(String pin);
}
