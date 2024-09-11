import 'package:xplor/features/my_orders/domain/entities/add_document_to_wallet_entity.dart';

import '../../domain/entities/my_orders_entity.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/status_entity_model.dart';
import '../../domain/repository/my_order_repository.dart';
import '../data_sources/my_orders_api_service.dart';

/// Implementation of [MyOrdersRepository] that interacts with the API service and manages network connectivity.
class MyOrdersRepositoryImpl implements MyOrdersRepository {
  final MyOrdersApiService apiService;
  final NetworkInfo networkInfo;

  MyOrdersRepositoryImpl({
    required this.apiService,
    required this.networkInfo,
  });

  /// Fetches ongoing orders data from the API service.
  @override
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex) async {
    if (await networkInfo.isConnected!) {
      return apiService.getOngoingOrdersData(initialIndex, lastIndex);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Fetches completed orders data from the API service.
  @override
  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex) async {
    if (await networkInfo.isConnected!) {
      return apiService.getCompletedOrdersData(initialIndex, lastIndex);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Rates an order using provided order ID, rating, and feedback.
  @override
  Future<bool> rateOrder(String orderId, String rating, String feedback) async {
    if (await networkInfo.isConnected!) {
      return apiService.rateOrder(orderId, rating, feedback);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Sends status request with provided body to check order status.
  @override
  Future<void> statusRequest(String data) async {
    if (await networkInfo.isConnected!) {
      return apiService.statusRequest(data);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  /// Establishes a Server-Sent Events (SSE) connection to receive status updates.
  @override
  Stream<StatusEntityModel> sseConnectionResponse(String transactionId, Duration timeout) {
    return apiService.sseConnectionResponse(transactionId, timeout);
  }

  @override
  Future<bool> uploadCertificateToWallet(AddDocumentToWalletEntity entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.uploadCertificateToWallet(entity);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> markAddToWallet(String orderId) async {
    if (await networkInfo.isConnected!) {
      return apiService.markAddToWallet(orderId);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }
}
