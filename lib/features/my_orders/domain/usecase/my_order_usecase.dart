import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';

import '../entities/status_entity_model.dart';
import '../repository/my_order_repository.dart';

class MyOrdersUseCase {
  MyOrdersRepository repository;

  MyOrdersUseCase({required this.repository});

  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex) async {
    return await repository.getOngoingOrdersData(initialIndex, lastIndex);
  }

  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex) async {
    return await repository.getCompletedOrdersData(initialIndex, lastIndex);
  }

  Future<bool> rateOrder(String orderId, String rating, String feedback) async {
    return await repository.rateOrder(orderId, rating, feedback);
  }

  Future<void> status(String body) async {
    return await repository.statusRequest(body);
  }

  Stream<StatusEntityModel> sseConnection({required String transactionId, required Duration timeout}) {
    return repository.sseConnectionResponse(transactionId, timeout);
  }
}
