import 'package:flutter/foundation.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/exception_errors.dart';
import '../../domain/entity/get_details_entity.dart';
import '../../domain/repository/course_details_repository.dart';
import '../data_sources/course_detail_service.dart';

class CourseDetailsRepositoryImpl implements CourseDetailsRepository {
  CourseDetailsRepositoryImpl({required this.apiService, required this.networkInfo});

  CourseDetailsApiService apiService;
  NetworkInfo networkInfo;

  @override
  Future<CourseDetailsEntity> getCourseDetails(String body) async {
    if (kDebugMode) {
      print("await networkInfo.isConnected!  ${await networkInfo.isConnected!}");
    }
    if (await networkInfo.isConnected!) {
      return apiService.getCourseDetails(body);
    } else {
      throw Exception(ExceptionErrors.checkInternetConnection.stringToString);
    }
  }
}
