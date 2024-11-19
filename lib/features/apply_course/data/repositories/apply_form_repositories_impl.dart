import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/get_response_entity/sse_services_entity.dart';
import '../../domain/repository/apply_form_repository.dart';
import '../data_sources/apply_form_service.dart';

class ApplyFormRepositoryImpl implements ApplyFormRepository {
  ApplyFormRepositoryImpl({required this.apiService, required this.networkInfo});

  ApplyFormsApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<void> selectRequest(String body) async {
    AppUtils.printLogs("await networkInfo.isConnected!  ${await networkInfo.isConnected!}");
    if (await networkInfo.isConnected!) {
      return apiService.selectRequest(body);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> initRequest(String body) async {
    if (await networkInfo.isConnected!) {
      return apiService.initRequest(body);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> confirmRequest(String data) async {
    if (await networkInfo.isConnected!) {
      return apiService.confirmRequest(data);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Stream<SseServicesEntity> sseConnectionResponse(String transactionId, Duration timeout) {
    return apiService.sseConnectionResponse(transactionId, timeout);
  }
}
