import 'package:xplor/features/on_boarding/domain/entities/e_auth_providers_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_assign_role_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';

import '../../../on_boarding/domain/entities/user_data_entity.dart';
import '../entities/categories_entity.dart';
import '../entities/domains_entity.dart';
import '../entities/kyc_sse_response.dart';
import '../entities/on_boarding_user_role_entity.dart';

abstract class OnBoardingRepository {
  Future<String> sendOtpOnBoarding(OnBoardingSendOtpEntity? entity);

  Future<void> verifyOtpOnBoarding(OnBoardingVerifyOtpEntity entity);

  Future<bool> assignRoleOnBoarding(OnBoardingAssignRoleEntity entity);

  Future<bool> updateUserKycOnBoarding();

  Future<bool> createMpin(String pin);

  Future<List<OnBoardingUserRoleEntity>> getUserRolesOnBoarding();

  Future<EAuthProviderEntity?> getEAuthProviders();

  Future<void> getUserJourney();

  Future<void> getAssignedRoleUserData();

  Future<bool> updateDevicePreference(Map<String, dynamic> data);

  Future<List<DomainData>> getDomainsList();

  Future<bool> getDeviceInfoApi(String domains);

  Future<List<CategoryEntity>> getCategories();

  Future<void> onCategoriesSave(List<String> categories);

  Future<UserDataEntity> getUserData();

  Stream<KycSseResponse> getKycStatusResponse(Duration timeout);
}
