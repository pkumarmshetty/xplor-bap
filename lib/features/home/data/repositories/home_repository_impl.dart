import '../../domain/entities/user_data_entity.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/repository/home_repository.dart';
import '../data_sources/home_api_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.apiService, required this.networkInfo});

  HomeApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<UserDataEntity> getUserData() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserData();
    } else {
      throw Exception(checkInternetConnection);
    }
  }
}
