part of 'course_ratings_bloc.dart';

abstract class CourseRatingsEvent extends Equatable {
  const CourseRatingsEvent();
}

class RatingsResetEvent extends CourseRatingsEvent {
  @override
  List<Object?> get props => [];
}

class RatingsUpdateEvent extends CourseRatingsEvent {
  final double ratings;
  final String feedback;

  @override
  List<Object?> get props => [ratings, feedback];

  const RatingsUpdateEvent({
    required this.ratings,
    required this.feedback,
  });
}

class RatingsSubmitEvent extends CourseRatingsEvent {
  final double ratings;
  final String feedback;

  @override
  List<Object?> get props => [ratings, feedback];

  const RatingsSubmitEvent({
    required this.ratings,
    required this.feedback,
  });
}
