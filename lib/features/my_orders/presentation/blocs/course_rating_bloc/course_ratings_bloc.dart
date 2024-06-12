import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xplor/features/my_orders/domain/usecase/my_order_usecase.dart';

part 'course_ratings_event.dart';
part 'course_ratings_state.dart';

class CourseRatingsBloc extends Bloc<CourseRatingsEvent, CourseRatingsState> {
  String orderId = '';
  MyOrdersUseCase myOrdersUseCase;

  CourseRatingsBloc({required this.myOrdersUseCase}) : super(CourseRatingsInitial()) {
    on<RatingsUpdateEvent>(_onRatingsUpdatedEvent);
    on<RatingsResetEvent>(_onRatingsResetEvent);
    on<RatingsSubmitEvent>(_onRatingsSubmitEvent);
  }

  FutureOr<void> _onRatingsUpdatedEvent(RatingsUpdateEvent event, Emitter<CourseRatingsState> emit) {
    if (state is CourseRatingsUpdatedState) {
      emit((state as CourseRatingsUpdatedState).copyWith(ratings: event.ratings, feedback: event.feedback));
    } else {
      emit(CourseRatingsUpdatedState(ratings: event.ratings, feedback: event.feedback, isLoading: false));
    }
  }

  FutureOr<void> _onRatingsResetEvent(RatingsResetEvent event, Emitter<CourseRatingsState> emit) {
    emit(CourseRatingsInitial());
  }

  FutureOr<void> _onRatingsSubmitEvent(RatingsSubmitEvent event, Emitter<CourseRatingsState> emit) async {
    try {
      emit((state as CourseRatingsUpdatedState).copyWith(loading: true));
      bool result = await myOrdersUseCase.rateOrder(orderId, event.ratings.toString(), event.feedback);
      emit((state as CourseRatingsUpdatedState).copyWith(loading: false));
      if (result) {
        emit(RatingsSubmittedSuccessState());
      } else {
        emit(CourseRatingsInitial());
      }
    } catch (e) {
      emit((state as CourseRatingsUpdatedState).copyWith(loading: false));
    }
  }
}
