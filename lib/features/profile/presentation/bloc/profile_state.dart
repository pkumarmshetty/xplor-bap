part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileUserDataLoadingState extends ProfileState {}

class ProfileUserDataFailureState extends ProfileState {}

final class ProfileUserDataState extends ProfileState {
  final ProfileUserDataEntity userData;

  const ProfileUserDataState({required this.userData});

  @override
  List<Object> get props => [userData];
}
