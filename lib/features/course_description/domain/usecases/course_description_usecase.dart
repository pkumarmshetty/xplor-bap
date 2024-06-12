import '../entity/get_details_entity.dart';
import '../repository/course_details_repository.dart';

class CourseDescriptionUsecase {
  CourseDetailsRepository repository;

  CourseDescriptionUsecase({required this.repository});

  Future<CourseDetailsEntity> getCourseDetails(String body) async {
    return await repository.getCourseDetails(body);
  }
}
