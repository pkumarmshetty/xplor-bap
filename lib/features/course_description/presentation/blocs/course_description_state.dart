import 'package:equatable/equatable.dart';
import '../../domain/entity/services_items.dart';

/// Base class for all states related to course description management.
abstract class CourseDescriptionState extends Equatable {
  /// Constructor for [CourseDescriptionState]. This is a const constructor to
  /// enable creating immutable state instances.
  const CourseDescriptionState();
}

/// Initial state for the course description feature.
///
/// This state is emitted when the [CourseDescriptionBloc] is first initialized.
class CourseDescriptionInitial extends CourseDescriptionState {
  @override
  List<Object> get props => [];
}

/// State indicating that course data is currently being loaded.
class CourseLoaderData extends CourseDescriptionState {
  @override
  List<Object> get props => [];
}

/// State representing the successfully selected course details.
class CourseSelectedState extends CourseDescriptionState {
  /// The detailed data of the selected course.
  final CourseDetailsDataEntity course;

  /// Constructs a [CourseSelectedState] with the required [course] data.
  const CourseSelectedState({
    required this.course,
  });

  @override
  List<Object> get props => [course];
}

/// State representing a failure in fetching course details.
class CourseDetailsFailureState extends CourseDescriptionState {
  /// The error message describing the failure.
  final String error;

  /// Constructs a [CourseDetailsFailureState] with the required [error] message.
  const CourseDetailsFailureState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
