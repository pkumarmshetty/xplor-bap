part of 'course_ratings_bloc.dart';

// Define the abstract class for states related to course ratings
abstract class CourseRatingsState extends Equatable {
  const CourseRatingsState();
}

// Initial state when the course ratings bloc is first created
class CourseRatingsInitial extends CourseRatingsState {
  @override
  List<Object> get props => [];
}

// State indicating that ratings were successfully submitted
class RatingsSubmittedSuccessState extends CourseRatingsState {
  @override
  List<Object> get props => [];
}

// State to represent updated ratings and feedback, with loading indicator
class CourseRatingsUpdatedState extends CourseRatingsState {
  final double ratings; // Current ratings value
  final String feedback; // Current feedback text
  final bool isLoading; // Loading state indicator

  @override
  List<Object> get props => [ratings, feedback, isLoading];

  const CourseRatingsUpdatedState({
    required this.ratings,
    required this.feedback,
    required this.isLoading,
  });

  // Copy method to create a new state with optionally updated fields
  CourseRatingsUpdatedState copyWith({
    double? ratings,
    String? feedback,
    bool? loading,
  }) {
    return CourseRatingsUpdatedState(
      ratings: ratings ?? this.ratings,
      feedback: feedback ?? this.feedback,
      isLoading: loading ?? isLoading,
    );
  }
}
