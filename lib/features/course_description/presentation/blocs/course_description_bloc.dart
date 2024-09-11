import 'dart:async';
import 'package:bloc/bloc.dart';
import 'course_description_event.dart';
import 'course_description_state.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../seeker_home/domain/entities/get_response_entity/services_items.dart';
import '../../domain/usecases/course_description_usecase.dart';

/// The [CourseDescriptionBloc] is responsible for handling the events
/// related to course descriptions and emitting corresponding states.
/// It extends [Bloc] with [CourseDescriptionEvent] as the event type
/// and [CourseDescriptionState] as the state type.
class CourseDescriptionBloc extends Bloc<CourseDescriptionEvent, CourseDescriptionState> {
  /// The data entity holding the selected course details.
  SearchItemEntity? data;

  /// The use case instance responsible for fetching course details.
  final CourseDescriptionUsecase usecase;

  /// Constructor for [CourseDescriptionBloc] which takes [CourseDescriptionUsecase]
  /// as a parameter. The initial state is set to [CourseDescriptionInitial].
  CourseDescriptionBloc(this.usecase) : super(CourseDescriptionInitial()) {
    // Register the event handler for CourseSelectedEvent.
    on<CourseSelectedEvent>(_onCourseSelectedEvent);
  }

  /// Event handler for [CourseSelectedEvent].
  /// It updates the state based on the outcome of fetching course details.
  FutureOr<void> _onCourseSelectedEvent(CourseSelectedEvent event, Emitter<CourseDescriptionState> emit) async {
    // Set the selected course data.
    data = event.course;

    try {
      // Emit a loading state while fetching course details.
      emit(CourseLoaderData());

      // Fetch the course details using the use case.
      var res = await usecase.getCourseDetails(data!.id);

      // Emit the state with the fetched course details.
      emit(CourseSelectedState(course: res.items!));
    } catch (e) {
      emit(CourseDetailsFailureState(error: AppUtils.getErrorMessage(e.toString())));
    }
  }
}
