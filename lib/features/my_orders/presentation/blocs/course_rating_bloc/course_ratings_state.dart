part of 'course_ratings_bloc.dart';

abstract class CourseRatingsState extends Equatable {
  const CourseRatingsState();
}

class CourseRatingsInitial extends CourseRatingsState {
  @override
  List<Object> get props => [];
}

class RatingsSubmittedSuccessState extends CourseRatingsState {
  @override
  List<Object> get props => [];
}

class CourseRatingsUpdatedState extends CourseRatingsState {
  final double ratings;
  final String feedback;
  final bool isLoading;

  @override
  List<Object> get props => [ratings, feedback, isLoading];

  const CourseRatingsUpdatedState({
    required this.ratings,
    required this.feedback,
    required this.isLoading,
  });

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
