import 'package:xplor/features/profile/data/data_sources/profile_api_service.dart';
import 'package:xplor/features/profile/domain/repository/profile_repository.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.apiService, required this.networkInfo});

  ProfileApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<UserDataEntity> getUserData() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserData();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> logout() async {
    if (await networkInfo.isConnected!) {
      return apiService.logout();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }
}
