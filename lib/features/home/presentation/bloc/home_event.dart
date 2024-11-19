part of 'home_bloc.dart';

/// Base class for all events that can be dispatched to the [HomeBloc].
///
/// Events in the BLoC pattern are used to trigger specific actions or state changes.
/// [HomeEvent] is an immutable class that extends [Equatable] to support equality comparison.
///
/// All events related to the home page should extend this class.
@immutable
sealed class HomeEvent extends Equatable {
  /// Constructor for [HomeEvent]. It doesn't take any parameters.
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeUserDataEvent extends HomeEvent {
  /// Constructor for [HomeUserDataEvent]. It doesn't take any parameters.
  const HomeUserDataEvent();
}

/// Event to trigger the loading of the profile view in the [HomeBloc].
class HomeProfileEvent extends HomeEvent {
  /// Constructor for [HomeProfileEvent]. It doesn't take any parameters.
  const HomeProfileEvent();
}
