part of 'kyc_bloc.dart';

sealed class KycState extends Equatable {
  const KycState();
  
  @override
  List<Object> get props => [];
}

final class KycInitial extends KycState {}
class KycSuccessState extends KycState {}
class KycLoadingState extends KycState {}
class KycErrorState extends KycState {
  const KycErrorState(this.error);
  final String error;
}

class KycFailedState extends KycState{}