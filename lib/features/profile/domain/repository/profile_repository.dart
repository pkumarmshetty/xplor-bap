import '../../../on_boarding/domain/entities/user_data_entity.dart';

/// Repository for interacting with user profile data.
abstract class ProfileRepository {
  /// Fetches the user's profile data.
  Future<UserDataEntity> getUserData();

  /// Performs a logout action for the user.
  Future<void> logout();
}
