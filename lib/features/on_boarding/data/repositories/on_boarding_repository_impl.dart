import 'package:xplor/features/on_boarding/data/data_sources/on_boarding_remote.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_user_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/dependency_injection.dart';
import '../../domain/entities/e_auth_providers_entity.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingApiService _apiService = sl<OnBoardingApiService>();
  final NetworkInfo networkInfo = sl<NetworkInfo>();

  @override
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity? entity) async {
    if (await networkInfo.isConnected!) {
      return _apiService.sendOtpOnBoarding(entity!);
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<void> resendOtpOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return _apiService.resendOtpOnBoarding();
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity) async {
    if (await networkInfo.isConnected!) {
      return _apiService.verifyOtpOnBoarding(entity);
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity) async {
    if (await networkInfo.isConnected!) {
      return _apiService.assignRoleOnBoarding(entity);
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<bool> updateUserKycOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return _apiService.updateUserKycOnBoarding();
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<EAuthProviderEntity?> getEAuthProviders() async {
    if (await networkInfo.isConnected!) {
      return EAuthProviderEntity.fromJson((await _apiService.getEAuthProviders())?.toJson() ?? {});
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    if (await networkInfo.isConnected!) {
      return _apiService.getUserRolesOnBoarding();
    } else {
      throw Exception("Check your internet connection");
    }
  }

  @override
  Future<void> getUserJourney() async {
    if (await networkInfo.isConnected!) {
      return _apiService.getUserJourney();
    } else {
      throw Exception("Check your internet connection");
    }
  }
}
