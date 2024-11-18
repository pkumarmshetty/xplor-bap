import '../entity/get_details_entity.dart';

/// Abstract Class for [CourseDetailsRepository]
abstract class CourseDetailsRepository {
  Future<CourseDetailsEntity> getCourseDetails(String body);
}
