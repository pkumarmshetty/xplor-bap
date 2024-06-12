import '../../../on_boarding/domain/entities/user_data_entity.dart';

abstract class HomeRepository {
  Future<UserDataEntity> getUserData();
}
