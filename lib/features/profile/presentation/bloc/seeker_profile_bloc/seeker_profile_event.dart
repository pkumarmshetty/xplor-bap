part of 'seeker_profile_bloc.dart';

sealed class SeekerProfileEvent extends Equatable {
  const SeekerProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileUserDataEvent extends SeekerProfileEvent {
  const ProfileUserDataEvent();
}

class ProfileAndTranslationEvent extends SeekerProfileEvent {
  final bool? isTranslationDone;

  const ProfileAndTranslationEvent({this.isTranslationDone});

  @override
  List<Object?> get props => [isTranslationDone];
}

class SeekerProfileLogoutEvent extends SeekerProfileEvent {
  const SeekerProfileLogoutEvent();
}
