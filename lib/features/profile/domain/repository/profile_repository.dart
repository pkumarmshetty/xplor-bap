import '../../../on_boarding/domain/entities/user_data_entity.dart';

abstract class ProfileRepository {
  Future<UserDataEntity> getUserData();

  Future<void> logout();
}
