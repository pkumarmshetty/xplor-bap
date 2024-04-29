import 'package:xplor/features/profile/domain/repository/profile_repository.dart';

import '../entities/profile_user_data_entity.dart';

class ProfileUseCase {
  ProfileRepository repository;

  ProfileUseCase({required this.repository});

  Future<ProfileUserDataEntity> getUserData() async {
    return await repository.getUserData();
  }
}
