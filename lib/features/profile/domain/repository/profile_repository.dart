import '../entities/profile_user_data_entity.dart';

abstract class ProfileRepository {
  Future<ProfileUserDataEntity> getUserData();
}
