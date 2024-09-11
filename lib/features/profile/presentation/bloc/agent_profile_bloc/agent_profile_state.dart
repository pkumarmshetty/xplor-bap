part of 'agent_profile_bloc.dart';

/// Represents the possible states of the agent profile.
enum ProfileState { loading, initial, done, userDataLoaded, failure }

/// Represents the state of the agent profile.
/// Extends Equatable for efficient state comparison.
class AgentProfileState extends Equatable {
  final ProfileState profileState;
  final UserDataEntity? userData;
  final String? message;
  final int? uniqueId;

  // Constructor with default values.
  const AgentProfileState({
    this.profileState = ProfileState.initial,
    this.userData,
    this.message,
    this.uniqueId,
  });

  /// Creates a new instance of AgentProfileState with updated values.
  AgentProfileState copyWith({
    ProfileState? profileState,
    UserDataEntity? userData,
    String? message,
    int? uniqueId,
  }) {
    return AgentProfileState(
      profileState: profileState ?? this.profileState,
      userData: userData ?? this.userData,
      message: message ?? this.message,
      uniqueId: uniqueId ?? this.uniqueId,
    );
  }

  /// Equatable props for efficient state comparison.
  @override
  List<Object?> get props => [profileState, userData, message, uniqueId];
}

/// Initial state of the agent profile.
/// Extends AgentProfileState with a unique identifier based on the current timestamp.
class ProfileInitialState extends AgentProfileState {
  ProfileInitialState() : super(uniqueId: DateTime.now().millisecondsSinceEpoch);
}

/// State representing a logout action for the agent profile.
/// Can be used to trigger logout-specific behavior.
class ProfileLogoutState extends AgentProfileState {}
