import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';
import '../../domain/usecases/home_usecases.dart';

part 'home_event.dart';

part 'home_state.dart';

/// [HomeBloc] is a BLoC (Business Logic Component) responsible for handling
/// the events and states related to the home page of the application.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// An instance of [HomeUseCase] used to fetch user data.
  final HomeUseCase homeUseCase;

  /// Constructor for [HomeBloc] which initializes with an instance of
  /// [HomeUseCase] and sets up event handlers.
  HomeBloc({required this.homeUseCase}) : super(HomeInitialState()) {
    // Registers the event handler for [HomeUserDataEvent].
    on<HomeUserDataEvent>(_onHomeInitial);
    // Registers the event handler for [HomeProfileEvent].
    on<HomeProfileEvent>(_onHomeProfile);
  }

  /// Event handler for [HomeUserDataEvent]. This function is responsible for
  /// loading user data and updating the state accordingly.
  ///
  /// - Emits [HomeInitialState] to indicate that the state is reset.
  /// - Emits [HomeUserDataLoadingState] to indicate data is being loaded.
  /// - Attempts to fetch user data from [homeUseCase].
  ///   - On success, emits [HomeUserDataState] with the fetched user data.
  ///   - On failure, emits [HomeUserDataFailureState].
  Future<void> _onHomeInitial(HomeUserDataEvent event, Emitter<HomeState> emit) async {
    // Reset to initial state.
    emit(HomeInitialState());
    // Indicate that data loading is in progress.
    emit(HomeUserDataLoadingState());
    try {
      // Attempt to fetch user data.
      final userData = await homeUseCase.getUserData();
      // Emit a state with the fetched user data.
      emit(HomeUserDataState(userData: userData));
    } catch (e) {
      // Emit a failure state if an error occurs.
      emit(HomeUserDataFailureState());
    }
  }

  /// Event handler for [HomeProfileEvent]. This function is responsible for
  /// setting the state to [HomeProfileState] when the profile event is triggered.
  ///
  /// - Emits [HomeProfileState] to indicate the profile view is active.
  Future<void> _onHomeProfile(HomeProfileEvent event, Emitter<HomeState> emit) async {
    // Emit the profile state.
    emit(HomeProfileState());
  }
}
