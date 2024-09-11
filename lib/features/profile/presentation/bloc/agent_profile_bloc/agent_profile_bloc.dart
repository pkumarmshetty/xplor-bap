import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecase/profile_usecase.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../on_boarding/domain/entities/user_data_entity.dart';

part 'agent_profile_event.dart';

part 'agent_profile_state.dart';

/// BLoC (Business Logic Component) responsible for managing the state of the agent's profile.
class AgentProfileBloc extends Bloc<AgentProfileEvent, AgentProfileState> {
  ProfileUseCase profileUseCase;
  UserDataEntity? userData;
  bool isTranslationDone = false;

  /// Constructor for the AgentProfileBloc.
  ///
  /// [profileUseCase] is a required dependency for interacting with profile data.
  AgentProfileBloc({required this.profileUseCase}) : super(ProfileInitialState()) {
    on<ProfileUserDataEvent>(_onProfileInitial);
    on<AgentProfileLogoutEvent>(_onLogout);
    on<ProfileAndTranslationEvent>(_onProfileTranslationDone);
  }

  /// Handles the `ProfileUserDataEvent` to fetch and update user profile data.
  Future<void> _onProfileInitial(ProfileUserDataEvent event, Emitter<AgentProfileState> emit) async {
    isTranslationDone = false;
    try {
      // Emit loading state while fetching data.
      emit(state.copyWith(
          profileState: ProfileState.loading, userData: null, uniqueId: DateTime.now().millisecondsSinceEpoch));

      // Fetch user data using the profileUseCase.
      userData = await profileUseCase.getUserData();

      // Check if the selected language is English.
      if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode) == "en") {
        // If English, emit the 'done' state with the fetched user data.
        emit(state.copyWith(
            profileState: ProfileState.done, userData: userData, uniqueId: DateTime.now().millisecondsSinceEpoch));
      } else {
        // If not English, emit the 'userDataLoaded' state, indicating that translation might be needed.
        emit(state.copyWith(
            profileState: ProfileState.userDataLoaded,
            userData: userData,
            uniqueId: DateTime.now().millisecondsSinceEpoch));
      }
    } catch (e) {
      // Handle errors by emitting a failure state with an error message.
      emit(state.copyWith(
          profileState: ProfileState.failure,
          userData: null,
          message: AppUtils.getErrorMessage(e.toString()),
          uniqueId: DateTime.now().millisecondsSinceEpoch));
      // Consider logging the exception for debugging purposes.
    }
  }

  /// Handles the `AgentProfileLogoutEvent` to log the user out.
  Future<void> _onLogout(AgentProfileLogoutEvent event, Emitter<AgentProfileState> emit) async {
    try {
      // Perform logout using the profileUseCase.
      await profileUseCase.logout();
      // Emit the logout state.
      emit(ProfileLogoutState());
    } catch (e) {
      // Handle and potentially log logout errors.
      throw Exception(e.toString());
    }
  }

  /// Handles the `ProfileAndTranslationEvent` to update the state based on translation status.
  FutureOr<void> _onProfileTranslationDone(ProfileAndTranslationEvent event, Emitter<AgentProfileState> emit) {
    AppUtils.printLogs("data..... ${event.isTranslationDone}");
    AppUtils.printLogs("data..... $userData");

    // Update translation status if not already done.
    if (!isTranslationDone && event.isTranslationDone != null) {
      isTranslationDone = true;
    }

    // If translation is done and user data is available, emit the 'done' state.
    if (isTranslationDone && userData != null) {
      emit(state.copyWith(
          profileState: ProfileState.done, userData: userData, uniqueId: DateTime.now().millisecondsSinceEpoch));
    }
  }
}
