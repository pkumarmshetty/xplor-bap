import 'package:xplor/features/wallet/domain/entities/wallet_add_document_entity.dart';

import '../entities/previous_consent_entity.dart';
import '../entities/wallet_vc_list_entity.dart';

import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';

import '../entities/update_consent_entity.dart';

abstract class WalletRepository {
  Future<String> getWalletData();

  Future<void> addDocumentWallet(WalletAddDocumentEntity? entity);

  Future<List<DocumentVcData>> getWalletVcList();

  Future<void> sharedWalletVcData(List<String> vcIds, String request);

  Future<void> deletedDocVcData(List<String> vcIds);

  Future<List<SharedVcDataEntity>> getMyConsents();

  Future<List<PreviousConsentEntity>> getMyPrevConsents();

  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId);

  Future<bool> revokeConsent(SharedVcDataEntity entity);

  Future<bool> verifyMpin(String pin);
}
