import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';
import '../../domain/usecases/home_usecases.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeUseCase homeUseCase;

  HomeBloc({required this.homeUseCase}) : super(HomeInitialState()) {
    on<HomeUserDataEvent>(_onHomeInitial);
    on<HomeProfileEvent>(_onHomeProfile);
  }

  Future<void> _onHomeInitial(HomeUserDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeInitialState());
    emit(HomeUserDataLoadingState());
    try {
      final userData = await homeUseCase.getUserData();
      emit(HomeUserDataState(userData: userData));
    } catch (e) {
      emit(HomeUserDataFailureState());
      //throw Exception(e.toString());
    }
  }

  Future<void> _onHomeProfile(HomeProfileEvent event, Emitter<HomeState> emit) async {
    emit(HomeProfileState());
  }
}
