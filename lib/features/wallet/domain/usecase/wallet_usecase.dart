import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';

import '../entities/previous_consent_entity.dart';
import '../entities/update_consent_entity.dart';
import '../entities/wallet_add_document_entity.dart';
import '../entities/wallet_vc_list_entity.dart';
import '../repository/wallet_repository.dart';

class WalletUseCase {
  WalletRepository repository;

  WalletUseCase({required this.repository});

  Future<String> getWalletId() async {
    return await repository.getWalletData();
  }

  Future<List<DocumentVcData>> getWalletVcData() async {
    return await repository.getWalletVcList();
  }

  Future<void> sharedWalletVcData(List<String> vcIds, String request) async {
    return await repository.sharedWalletVcData(vcIds, request);
  }

  Future<void> deletedDocVcList(List<String> vcIds) async {
    return await repository.deletedDocVcData(vcIds);
  }

  Future<List<SharedVcDataEntity>> getMyConsents() async {
    return await repository.getMyConsents();
  }

  Future<List<PreviousConsentEntity>> getMyPrevConsents() async {
    return await repository.getMyPrevConsents();
  }

  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId) async {
    return await repository.updateConsent(entity, requestId);
  }

  Future<bool> revokeConsent(SharedVcDataEntity entity) async {
    return await repository.revokeConsent(entity);
  }

  Future<bool> verifyMpin(String pin) async {
    return await repository.verifyMpin(pin);
  }

  Future<void> addDocumentWallet(WalletAddDocumentEntity params) async {
    return await repository.addDocumentWallet(params);
  }
}
