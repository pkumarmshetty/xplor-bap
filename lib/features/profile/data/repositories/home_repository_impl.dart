import 'package:xplor/features/profile/data/data_sources/profile_api_service.dart';
import 'package:xplor/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/profile_user_data_entity.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.apiService, required this.networkInfo});

  ProfileApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<ProfileUserDataEntity> getUserData() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserData();
    } else {
      throw Exception(checkInternetConnection);
    }
  }
}
