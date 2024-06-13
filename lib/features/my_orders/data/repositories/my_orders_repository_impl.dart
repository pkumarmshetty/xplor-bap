import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/status_entity_model.dart';
import '../../domain/repository/my_order_repository.dart';
import '../data_sources/my_orders_api_service.dart';

class MyOrdersRepositoryImpl implements MyOrdersRepository {
  MyOrdersRepositoryImpl({required this.apiService, required this.networkInfo});

  MyOrdersApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<MyOrdersListEntity> getOngoingOrdersData(String initialIndex, String lastIndex) async {
    if (await networkInfo.isConnected!) {
      return apiService.getOngoingOrdersData(initialIndex, lastIndex);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<MyOrdersListEntity> getCompletedOrdersData(String initialIndex, String lastIndex) async {
    if (await networkInfo.isConnected!) {
      return apiService.getCompletedOrdersData(initialIndex, lastIndex);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> rateOrder(String orderId, String rating, String feedback) async {
    if (await networkInfo.isConnected!) {
      return apiService.rateOrder(orderId, rating, feedback);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> statusRequest(String data) async {
    if (await networkInfo.isConnected!) {
      return apiService.statusRequest(data);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Stream<StatusEntityModel> sseConnectionResponse(String transactionId, Duration timeout) {
    return apiService.sseConnectionResponse(transactionId, timeout);
  }
}
