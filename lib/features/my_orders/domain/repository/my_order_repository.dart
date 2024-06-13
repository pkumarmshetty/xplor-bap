import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';
import 'package:xplor/features/my_orders/domain/entities/status_entity_model.dart';

abstract class MyOrdersRepository {
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex);

  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex);

  Future<bool> rateOrder(String orderId, String rating, String feedback);

  Future<void> statusRequest(String body);

  Stream<StatusEntityModel> sseConnectionResponse(String transactionId, Duration timeout);
}
