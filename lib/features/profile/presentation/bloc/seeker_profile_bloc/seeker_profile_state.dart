part of 'seeker_profile_bloc.dart';

/// Enumeration representing different states of the profile.
enum ProfileState {
  loading, // Profile data is currently being loaded.
  initial, // Initial state before any actions are taken.
  done, // Profile actions have been completed successfully.
  userDataLoaded, // User data has been successfully loaded.
  failure // An error occurred while loading or processing profile data.
}

/// Base state class for the seeker profile, implementing Equatable for efficient state comparisons.
class SeekerProfileState extends Equatable {
  // Current state of the profile.
  final ProfileState profileState;

  // Optional user data associated with the profile.
  final UserDataEntity? userData;

  // Optional message for additional state information or error messages.
  final String? message;

  // Unique identifier to differentiate state instances, often used for UI updates.
  final int? uniqueId;

  // Constructor for SeekerProfileState with default and named parameters.
  const SeekerProfileState({
    this.profileState = ProfileState.initial, // Default state is initial.
    this.userData, // Optional user data.
    this.message, // Optional message.
    this.uniqueId, // Optional unique identifier.
  });

  // Creates a copy of the current state with overridden values.
  // This method allows for updating parts of the state without creating a new instance from scratch.
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

  // Equatable override to specify properties used for comparison.
  // This helps in comparing state instances efficiently, especially in Bloc-based state management.
  @override
  List<Object?> get props => [profileState, userData, message, uniqueId];
}

/// Initial state of the profile, which is a subclass of SeekerProfileState.
/// Sets a unique ID based on the current timestamp to distinguish this state.
class ProfileInitialState extends SeekerProfileState {
  ProfileInitialState() : super(uniqueId: DateTime.now().millisecondsSinceEpoch);
}

/// State indicating that the user has logged out.
/// This can be used to trigger UI changes or other actions related to user logout.
class ProfileLogoutState extends SeekerProfileState {}
