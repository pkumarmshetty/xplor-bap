part of 'course_ratings_bloc.dart';

// Define the abstract class for events related to course ratings
abstract class CourseRatingsEvent extends Equatable {
  const CourseRatingsEvent();
}

// Event to reset ratings and feedback to initial state
class RatingsResetEvent extends CourseRatingsEvent {
  @override
  List<Object?> get props => [];

  // Constructor for creating a RatingsResetEvent
  const RatingsResetEvent();
}

// Event to update ratings and feedback
class RatingsUpdateEvent extends CourseRatingsEvent {
  final double ratings; // Updated ratings value
  final String feedback; // Updated feedback text

  @override
  List<Object?> get props => [ratings, feedback];

  // Constructor for creating a RatingsUpdateEvent
  const RatingsUpdateEvent({
    required this.ratings,
    required this.feedback,
  });
}

// Event to submit ratings and feedback
class RatingsSubmitEvent extends CourseRatingsEvent {
  final double ratings; // Ratings to be submitted
  final String feedback; // Feedback to be submitted

  @override
  List<Object?> get props => [ratings, feedback];

  // Constructor for creating a RatingsSubmitEvent
  const RatingsSubmitEvent({
    required this.ratings,
    required this.feedback,
  });
}
