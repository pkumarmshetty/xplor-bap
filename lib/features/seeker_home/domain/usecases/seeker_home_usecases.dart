import 'package:xplor/features/seeker_home/domain/repository/seeker_home_repository.dart';

import '../entities/get_response_entity/services_entity.dart';
import '../entities/post_request_entity/search_post_entity.dart';

class SeekerHomeUseCase {
  SeekerHomeRepository repository;

  SeekerHomeUseCase({required this.repository});

  Future<ServicesSearchEntity> search(SearchPostEntity searchEntity) async {
    return await repository.search(searchEntity);
  }
}
