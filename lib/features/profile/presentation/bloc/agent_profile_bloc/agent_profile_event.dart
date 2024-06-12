part of 'agent_profile_bloc.dart';

sealed class AgentProfileEvent extends Equatable {
  const AgentProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUserDataEvent extends AgentProfileEvent {
  const ProfileUserDataEvent();
}

class ProfileAndTranslationEvent extends AgentProfileEvent {
  final bool? isTranslationDone;

  const ProfileAndTranslationEvent({this.isTranslationDone});

  @override
  List<Object?> get props => [isTranslationDone];
}

class AgentProfileLogoutEvent extends AgentProfileEvent {
  const AgentProfileLogoutEvent();
}
