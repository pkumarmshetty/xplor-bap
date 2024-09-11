import '../entities/get_response_entity/sse_services_entity.dart';

abstract class ApplyFormRepository {
  Future<void> selectRequest(String body);

  Future<void> initRequest(String body);

  Future<void> confirmRequest(String body);

  Stream<SseServicesEntity> sseConnectionResponse(String transactionId, Duration timeout);
}
