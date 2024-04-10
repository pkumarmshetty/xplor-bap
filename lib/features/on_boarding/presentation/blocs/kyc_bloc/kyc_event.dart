part of 'kyc_bloc.dart';

sealed class KycEvent extends Equatable {
  const KycEvent();


  @override
  List<Object> get props => [];
}
class UpdateUserKycEvent extends KycEvent {
  const UpdateUserKycEvent();
}