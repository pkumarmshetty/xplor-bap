import 'package:equatable/equatable.dart';

import '../../domain/entity/services_items.dart';

abstract class CourseDescriptionState extends Equatable {
  const CourseDescriptionState();
}

class CourseDescriptionInitial extends CourseDescriptionState {
  @override
  List<Object> get props => [];
}

class CourseLoaderData extends CourseDescriptionState {
  @override
  List<Object> get props => [];
}

class CourseSelectedState extends CourseDescriptionState {
  final CourseDetailsDataEntity course;

  @override
  List<Object> get props => [course];

  const CourseSelectedState({
    required this.course,
  });
}

class CourseDetailsFailureState extends CourseDescriptionState {
  final String error;

  @override
  List<Object> get props => [error];

  const CourseDetailsFailureState({
    required this.error,
  });
}
