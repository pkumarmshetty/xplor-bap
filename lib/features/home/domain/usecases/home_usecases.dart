import '../../../on_boarding/domain/entities/user_data_entity.dart';
import '../repository/home_repository.dart';

/// Home Use Cases
class HomeUseCase {
  HomeRepository repository;

  HomeUseCase({required this.repository});

  Future<UserDataEntity> getUserData() async {
    return await repository.getUserData();
  }
}
