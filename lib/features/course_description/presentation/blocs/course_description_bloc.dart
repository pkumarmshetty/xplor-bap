import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:xplor/features/course_description/presentation/blocs/course_description_event.dart';
import 'package:xplor/features/course_description/presentation/blocs/course_description_state.dart';

import '../../../../utils/app_utils/app_utils.dart';
import '../../../seeker_home/domain/entities/get_response_entity/services_items.dart';
import '../../domain/usecases/course_description_usecase.dart';

class CourseDescriptionBloc extends Bloc<CourseDescriptionEvent, CourseDescriptionState> {
  SearchItemEntity? data;

  CourseDescriptionUsecase usecase;

  CourseDescriptionBloc(this.usecase) : super(CourseDescriptionInitial()) {
    //on<SeekerHomeUserDataEvent>(_onSeekerHomeInitial);
    on<CourseSelectedEvent>(_onCourseSelectedEvent);
  }

  FutureOr<void> _onCourseSelectedEvent(CourseSelectedEvent event, Emitter<CourseDescriptionState> emit) async {
    data = event.course;

    try {
      emit(CourseLoaderData());
      var res = await usecase.getCourseDetails(data!.id);

      emit(CourseSelectedState(course: res.items!));
    } catch (e) {
      emit(CourseDetailsFailureState(error: AppUtils.getErrorMessage(e.toString())));
    }
  }
}
