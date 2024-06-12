part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeUserDataEvent extends HomeEvent {
  const HomeUserDataEvent();
}

class HomeProfileEvent extends HomeEvent {
  const HomeProfileEvent();
}
