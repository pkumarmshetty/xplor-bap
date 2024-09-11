import 'package:xplor/features/my_orders/domain/entities/add_document_to_wallet_entity.dart';

import '../entities/my_orders_entity.dart';
import '../entities/status_entity_model.dart';
import '../repository/my_order_repository.dart';

/// Use case class that encapsulates business logic related to My Orders.
class MyOrdersUseCase {
  final MyOrdersRepository repository;

  MyOrdersUseCase({required this.repository});

  /// Fetches ongoing orders data from the repository.
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex) async {
    return await repository.getOngoingOrdersData(initialIndex, lastIndex);
  }

  /// Fetches completed orders data from the repository.
  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex) async {
    return await repository.getCompletedOrdersData(initialIndex, lastIndex);
  }

  /// Rates an order using provided order ID, rating, and feedback.
  Future<bool> rateOrder(String orderId, String rating, String feedback) async {
    return await repository.rateOrder(orderId, rating, feedback);
  }

  /// Sends status request with provided body to check order status.
  Future<void> status(String body) async {
    return await repository.statusRequest(body);
  }

  /// Establishes a Server-Sent Events (SSE) connection to receive status updates.
  Stream<StatusEntityModel> sseConnection({required String transactionId, required Duration timeout}) {
    return repository.sseConnectionResponse(transactionId, timeout);
  }

  /// Upload certificate in wallet
  Future<bool> uploadCertificateToWallet(AddDocumentToWalletEntity entity) async {
    return await repository.uploadCertificateToWallet(entity);
  }

  Future<void> markAddToWallet(String orderId) async {
    return await repository.markAddToWallet(orderId);
  }
}
