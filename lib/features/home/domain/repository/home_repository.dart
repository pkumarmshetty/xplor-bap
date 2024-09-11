import '../../../on_boarding/domain/entities/user_data_entity.dart';

///Home Repository
abstract class HomeRepository {
  Future<UserDataEntity> getUserData();
}
