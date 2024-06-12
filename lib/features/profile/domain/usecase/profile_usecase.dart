import 'package:xplor/features/profile/domain/repository/profile_repository.dart';

import '../../../on_boarding/domain/entities/user_data_entity.dart';

class ProfileUseCase {
  ProfileRepository repository;

  ProfileUseCase({required this.repository});

  Future<UserDataEntity> getUserData() async {
    return await repository.getUserData();
  }

  Future<void> logout() async {
    return await repository.logout();
  }
}
