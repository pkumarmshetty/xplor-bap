import '../entities/add_document_to_wallet_entity.dart';
import '../entities/my_orders_entity.dart';
import '../entities/status_entity_model.dart';

/// My Orders Repository.
abstract class MyOrdersRepository {
  /// Get Ongoing Orders
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex);

  /// Get Completed Orders
  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex);

  /// Rate Order
  Future<bool> rateOrder(String orderId, String rating, String feedback);

  /// Status Request
  Future<void> statusRequest(String body);

  /// Sse Connection
  Stream<StatusEntityModel> sseConnectionResponse(String transactionId, Duration timeout);

  Future<bool> uploadCertificateToWallet(AddDocumentToWalletEntity entity);

  Future<void> markAddToWallet(String orderId);
}
