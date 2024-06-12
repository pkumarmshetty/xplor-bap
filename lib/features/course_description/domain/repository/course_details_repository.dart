import '../entity/get_details_entity.dart';

abstract class CourseDetailsRepository {
  Future<CourseDetailsEntity> getCourseDetails(String body);
}
