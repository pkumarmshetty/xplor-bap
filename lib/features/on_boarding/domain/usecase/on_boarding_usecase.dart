import '../entities/user_data_entity.dart';
import '../entities/e_auth_providers_entity.dart';
import '../entities/ob_boarding_verify_otp_entity.dart';
import '../entities/on_boarding_assign_role_entity.dart';
import '../entities/on_boarding_send_otp_entity.dart';
import '../repository/on_boarding_repository.dart';
import '../../../../core/use_case.dart';
import '../entities/categories_entity.dart';
import '../entities/domains_entity.dart';
import '../entities/kyc_sse_response.dart';
import '../entities/on_boarding_user_role_entity.dart';

class OnBoardingUseCase implements UseCase<void, OnBoardingSendOtpEntity> {
  OnBoardingRepository repository;

  OnBoardingUseCase({required this.repository});

  @override
  Future<String> call({OnBoardingSendOtpEntity? params}) async {
    return await repository.sendOtpOnBoarding(params!);
  }

  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity params) async {
    return await repository.verifyOtpOnBoarding(params);
  }

  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity params) async {
    return await repository.assignRoleOnBoarding(params);
  }

  Future<bool> updateUserKycOnBoarding() async {
    return await repository.updateUserKycOnBoarding();
  }

  Future<EAuthProviderEntity?> getEAuthProviders() async {
    return await repository.getEAuthProviders();
  }

  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding() async {
    return await repository.getUserRolesOnBoarding();
  }

  Future<void> getUserJourney() async {
    return await repository.getUserJourney();
  }

  Future<bool> createMpin(String pin) async {
    return await repository.createMpin(pin);
  }

  Future<void> getAssignedRoleUserData() async {
    return await repository.getAssignedRoleUserData();
  }

  Future<bool> updateDevicePreference(Map<String, dynamic> data) async {
    return await repository.updateDevicePreference(data);
  }

  Future<List<DomainData>> getDomains() async {
    return await repository.getDomainsList();
  }

  Future<bool> getDeviceIdEvent(String deviceId) async {
    return await repository.getDeviceInfoApi(deviceId);
  }

  Future<List<CategoryEntity>> getCategories() async {
    return await repository.getCategories();
  }

  Future<UserDataEntity> getUserData() async {
    return await repository.getUserData();
  }

  Stream<KycSseResponse> getKycSuccessStatusResponse(Duration timeout) {
    return repository.getKycStatusResponse(timeout);
  }
}
