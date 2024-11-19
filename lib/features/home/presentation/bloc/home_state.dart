part of 'home_bloc.dart';

/// Base class for all possible states in the [HomeBloc].
@immutable
sealed class HomeState extends Equatable {
  /// Default constructor for the [HomeState] class.
  const HomeState();

  /// Overriding the `props` getter from [Equatable] to enable property-based
  @override
  List<Object> get props => [];
}

/// State representing the initial condition of the [HomeBloc].
class HomeInitialState extends HomeState {}

/// State indicating that user data is currently being loaded.
class HomeUserDataLoadingState extends HomeState {}

/// State indicating that the profile view should be displayed.
class HomeProfileState extends HomeState {}

/// State indicating that there was a failure in loading user data..
class HomeUserDataFailureState extends HomeState {}

/// State containing successfully loaded user data.
final class HomeUserDataState extends HomeState {
  /// The user data that has been retrieved.
  final UserDataEntity userData;

  /// Constructor for the [HomeUserDataState] class.
  const HomeUserDataState({required this.userData});

  @override
  List<Object> get props => [userData];
}
