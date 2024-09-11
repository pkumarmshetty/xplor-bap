import '../data_sources/on_boarding_remote.dart';
import '../../domain/entities/ob_boarding_verify_otp_entity.dart';
import '../../domain/entities/on_boarding_assign_role_entity.dart';
import '../../domain/entities/on_boarding_send_otp_entity.dart';
import '../../domain/entities/on_boarding_user_role_entity.dart';
import '../../domain/repository/on_boarding_repository.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/categories_entity.dart';
import '../../domain/entities/domains_entity.dart';
import '../../domain/entities/e_auth_providers_entity.dart';
import '../../domain/entities/kyc_sse_response.dart';
import '../../domain/entities/user_data_entity.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  OnBoardingRepositoryImpl({required this.apiService, required this.networkInfo});

  OnBoardingApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity? entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.sendOtpOnBoarding(entity!);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.verifyOtpOnBoarding(entity);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.assignRoleOnBoarding(entity);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> updateUserKycOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return apiService.updateUserKycOnBoarding();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<EAuthProviderEntity?> getEAuthProviders() async {
    if (await networkInfo.isConnected!) {
      return EAuthProviderEntity.fromJson((await apiService.getEAuthProviders())?.toJson() ?? {});
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserRolesOnBoarding();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> getUserJourney() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserJourney();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> createMpin(String pin) async {
    if (await networkInfo.isConnected!) {
      return apiService.createMpin(pin);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> getAssignedRoleUserData() async {
    if (await networkInfo.isConnected!) {
      return apiService.getAssignedRoleUserData();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> updateDevicePreference(Map<String, dynamic> data) async {
    if (await networkInfo.isConnected!) {
      return apiService.updateDevicePreference(data);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<List<DomainData>> getDomainsList() async {
    if (await networkInfo.isConnected!) {
      return apiService.getDomainsList();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<bool> getDeviceInfoApi(String deviceId) async {
    if (await networkInfo.isConnected!) {
      return apiService.getDeviceInfo(deviceId);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    if (await networkInfo.isConnected!) {
      return apiService.getCategories();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<void> onCategoriesSave(List<String> categories) async {
    if (await networkInfo.isConnected!) {
      return apiService.onCategoriesSave(categories);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Future<UserDataEntity> getUserData() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserData();
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }

  @override
  Stream<KycSseResponse> getKycStatusResponse(Duration timeout) {
    return apiService.getKycSuccessStatus(timeout);
  }
}
