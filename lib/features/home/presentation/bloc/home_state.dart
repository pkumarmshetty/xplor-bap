part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeUserDataLoadingState extends HomeState {}

class HomeProfileState extends HomeState {}

class HomeUserDataFailureState extends HomeState {}

final class HomeUserDataState extends HomeState {
  final UserDataEntity userData;

  const HomeUserDataState({required this.userData});

  @override
  List<Object> get props => [userData];
}
