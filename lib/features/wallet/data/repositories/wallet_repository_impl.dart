import '../../domain/entities/shared_data_entity.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/previous_consent_entity.dart';
import '../../domain/entities/wallet_vc_list_entity.dart';
import '../../domain/entities/update_consent_entity.dart';
import '../../domain/repository/wallet_repository.dart';
import '../data_sources/wallet_data_sources.dart';
import '../../domain/entities/wallet_add_document_entity.dart';

/// Implementation class for wallet repository.
class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({required this.apiService, required this.networkInfo});

  WalletApiService apiService;
  NetworkInfo networkInfo;

  /// Method to add document to wallet.
  @override
  Future<void> addDocumentWallet(WalletAddDocumentEntity? entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.addDocumentWallet(entity!);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to get wallet id.
  @override
  Future<String> getWalletData() async {
    if (await networkInfo.isConnected!) {
      return apiService.getWalletId();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to get wallet vc data.
  @override
  Future<List<DocumentVcData>> getWalletVcList() async {
    if (await networkInfo.isConnected!) {
      return apiService.getWalletVcData();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to share wallet vc data.
  @override
  Future<void> sharedWalletVcData(List<String> vcIds, String request) async {
    if (await networkInfo.isConnected!) {
      return apiService.sharedVcId(vcIds, request);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to delete wallet vc data.
  @override
  Future<void> deletedDocVcData(List<String> vcIds) async {
    if (await networkInfo.isConnected!) {
      return apiService.deletedVcIds(vcIds);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to get my consents.
  @override
  Future<List<SharedVcDataEntity>> getMyConsents() async {
    if (await networkInfo.isConnected!) {
      return apiService.getMyConsents();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to get my previous consents.
  @override
  Future<List<PreviousConsentEntity>> getMyPrevConsents() async {
    if (await networkInfo.isConnected!) {
      return apiService.getMyPrevConsents();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to update consent.
  @override
  Future<bool> updateConsent(UpdateConsentEntity entity, String requestId) async {
    if (await networkInfo.isConnected!) {
      return apiService.updateConsent(entity, requestId);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to revoke consent.
  @override
  Future<bool> revokeConsent(SharedVcDataEntity entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.revokeConsent(entity);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Method to verify mpin.
  @override
  Future<bool> verifyMpin(String pin) async {
    if (await networkInfo.isConnected!) {
      return apiService.verifyMpin(pin);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }
}
