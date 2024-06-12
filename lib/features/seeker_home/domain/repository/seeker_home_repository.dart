import '../entities/get_response_entity/services_entity.dart';
import '../entities/post_request_entity/search_post_entity.dart';

abstract class SeekerHomeRepository {
  Future<ServicesSearchEntity> search(SearchPostEntity data);
}
