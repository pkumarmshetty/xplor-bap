import 'package:xplor/features/on_boarding/domain/entities/e_auth_providers_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/repository/on_boarding_repository.dart';

import '../../../../core/dependency_injection.dart';
import '../../../../core/use_case.dart';
import '../entities/on_boarding_user_role_entity.dart';

class OnBoardingUseCase implements UseCase<void, OnBoardingSendOtpEntity> {
  final OnBoardingRepository _repository = sl<OnBoardingRepository>();

  @override
  Future<String> call({OnBoardingSendOtpEntity? params}) async {
    return await _repository.sendOtpOnBoarding(params!);
  }

  Future<void> resendOtpOnBoarding() async {
    return await _repository.resendOtpOnBoarding();
  }

  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity params) async {
    return await _repository.verifyOtpOnBoarding(params);
  }

  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity params) async {
    return await _repository.assignRoleOnBoarding(params);
  }

  Future<bool> updateUserKycOnBoarding() async {
    return await _repository.updateUserKycOnBoarding();
  }

  Future<EAuthProviderEntity?> getEAuthProviders() async {
    return await _repository.getEAuthProviders();
  }

  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    return await _repository.getUserRolesOnBoarding();
  }

  Future<void> getUserJourney() async {
    return await _repository.getUserJourney();
  }
}
