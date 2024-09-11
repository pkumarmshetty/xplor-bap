import '../data_sources/seeker_home_api_service.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/get_response_entity/services_entity.dart';
import '../../domain/entities/post_request_entity/search_post_entity.dart';
import '../../domain/repository/seeker_home_repository.dart';

/// Seeker home repository implementation
class SeekerHomeRepositoryImpl implements SeekerHomeRepository {
  SeekerHomeRepositoryImpl({required this.apiService, required this.networkInfo});

  SeekerHomeApiService apiService;
  NetworkInfo networkInfo;

  ///Search method
  @override
  Future<ServicesSearchEntity> search(SearchPostEntity data) async {
    if (await networkInfo.isConnected!) {
      return apiService.search(data);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }
}
