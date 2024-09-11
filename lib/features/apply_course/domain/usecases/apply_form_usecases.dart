import '../entities/get_response_entity/sse_services_entity.dart';

import '../repository/apply_form_repository.dart';

class ApplyFormUseCase {
  ApplyFormRepository repository;

  ApplyFormUseCase({required this.repository});

  Future<void> init(String body) async {
    return await repository.initRequest(body);
  }

  Future<void> select(String body) async {
    return await repository.selectRequest(body);
  }

  Future<void> confirm(String body) async {
    return await repository.confirmRequest(body);
  }

  Stream<SseServicesEntity> sseConnection({required String transactionId, required Duration timeout}) {
    return repository.sseConnectionResponse(transactionId, timeout);
  }
}
