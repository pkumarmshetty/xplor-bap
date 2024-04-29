import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xplor/features/profile/domain/usecase/profile_usecase.dart';

import '../../domain/entities/profile_user_data_entity.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileUseCase profileUseCase;

  ProfileBloc({required this.profileUseCase}) : super(ProfileInitialState()) {
    on<ProfileUserDataEvent>(_onHomeInitial);
  }

  Future<void> _onHomeInitial(ProfileUserDataEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileUserDataLoadingState());
    try {
      final userData = await profileUseCase.getUserData();
      emit(ProfileUserDataState(userData: userData));
    } catch (e) {
      emit(ProfileUserDataFailureState());
      //throw Exception(e.toString());
    }
  }
}
