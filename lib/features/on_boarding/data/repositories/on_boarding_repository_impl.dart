import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entities/e_auth_providers_entity.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  OnBoardingRepositoryImpl({required this.apiService, required this.networkInfo});

  OnBoardingApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity? entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.sendOtpOnBoarding(entity!);
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.verifyOtpOnBoarding(entity);
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity) async {
    if (await networkInfo.isConnected!) {
      return apiService.assignRoleOnBoarding(entity);
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<bool> updateUserKycOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return apiService.updateUserKycOnBoarding();
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<EAuthProviderEntity?> getEAuthProviders() async {
    if (await networkInfo.isConnected!) {
      return EAuthProviderEntity.fromJson((await apiService.getEAuthProviders())?.toJson() ?? {});
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserRolesOnBoarding();
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<void> getUserJourney() async {
    if (await networkInfo.isConnected!) {
      return apiService.getUserJourney();
    } else {
      throw Exception(checkInternetConnection);
    }
  }

  @override
  Future<bool> createMpin(String pin) async {
    if (await networkInfo.isConnected!) {
      return apiService.createMpin(pin);
    } else {
      throw Exception(checkInternetConnection);
    }
  }
}
