import 'package:xplor/features/home/domain/entities/user_data_entity.dart';

abstract class HomeRepository {
  Future<UserDataEntity> getUserData();
}
