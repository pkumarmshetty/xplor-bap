import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecase/my_order_usecase.dart';

part 'course_ratings_event.dart'; // Importing event classes
part 'course_ratings_state.dart'; // Importing state classes

/// Bloc responsible for managing course ratings related states and events.
class CourseRatingsBloc extends Bloc<CourseRatingsEvent, CourseRatingsState> {
  String orderId = ''; // ID of the order being rated
  MyOrdersUseCase myOrdersUseCase; // Instance of MyOrdersUseCase for business logic

  /// Constructor initializes the bloc with CourseRatingsInitial state
  /// and sets up event handlers for RatingsUpdateEvent, RatingsResetEvent,
  /// and RatingsSubmitEvent.
  CourseRatingsBloc({required this.myOrdersUseCase}) : super(CourseRatingsInitial()) {
    on<RatingsUpdateEvent>(_onRatingsUpdatedEvent);
    on<RatingsResetEvent>(_onRatingsResetEvent);
    on<RatingsSubmitEvent>(_onRatingsSubmitEvent);
  }

  /// Handles RatingsUpdateEvent to update ratings and feedback in the state.
  FutureOr<void> _onRatingsUpdatedEvent(RatingsUpdateEvent event, Emitter<CourseRatingsState> emit) {
    if (state is CourseRatingsUpdatedState) {
      emit((state as CourseRatingsUpdatedState).copyWith(ratings: event.ratings, feedback: event.feedback));
    } else {
      emit(CourseRatingsUpdatedState(ratings: event.ratings, feedback: event.feedback, isLoading: false));
    }
  }

  /// Handles RatingsResetEvent to reset ratings and feedback to initial state.
  FutureOr<void> _onRatingsResetEvent(RatingsResetEvent event, Emitter<CourseRatingsState> emit) {
    emit(CourseRatingsInitial());
  }

  /// Handles RatingsSubmitEvent to submit ratings and feedback.
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
