part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileUserDataEvent extends ProfileEvent {
  const ProfileUserDataEvent();
}
