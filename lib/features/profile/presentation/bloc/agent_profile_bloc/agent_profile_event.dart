part of 'agent_profile_bloc.dart';

/// Defines the various events that can be triggered within the AgentProfileBloc.
sealed class AgentProfileEvent extends Equatable {
  const AgentProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to trigger fetching and updating the user's profile data.
class ProfileUserDataEvent extends AgentProfileEvent {
  const ProfileUserDataEvent();
}

/// Event to handle profile updates and indicate whether translation is complete.
class ProfileAndTranslationEvent extends AgentProfileEvent {
  final bool? isTranslationDone;

  const ProfileAndTranslationEvent({this.isTranslationDone});

  @override
  List<Object?> get props => [isTranslationDone];
}

/// Event to trigger a logout action for the agent profile.
class AgentProfileLogoutEvent extends AgentProfileEvent {
  const AgentProfileLogoutEvent();
}
