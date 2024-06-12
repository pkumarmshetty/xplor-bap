part of 'seeker_profile_bloc.dart';

enum ProfileState { loading, initial, done, userDataLoaded, failure }

class SeekerProfileState extends Equatable {
  final ProfileState profileState;
  final UserDataEntity? userData;
  final String? message;
  final int? uniqueId;

  const SeekerProfileState({
    this.profileState = ProfileState.initial,
    this.userData,
    this.message,
    this.uniqueId,
  });

  SeekerProfileState copyWith({
    ProfileState? profileState,
    UserDataEntity? userData,
    String? message,
    int? uniqueId,
  }) {
    return SeekerProfileState(
      profileState: profileState ?? this.profileState,
      userData: userData ?? this.userData,
      message: message ?? this.message,
      uniqueId: uniqueId ?? this.uniqueId,
    );
  }

  @override
  List<Object?> get props => [profileState, userData, message, uniqueId];
}

class ProfileInitialState extends SeekerProfileState {
  ProfileInitialState() : super(uniqueId: DateTime.now().millisecondsSinceEpoch);
}

class ProfileLogoutState extends SeekerProfileState {}
