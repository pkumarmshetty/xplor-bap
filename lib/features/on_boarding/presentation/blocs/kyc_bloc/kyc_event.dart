part of 'kyc_bloc.dart';

sealed class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserKycEvent extends KycEvent {
  const UpdateUserKycEvent();
}

class EAuthSuccessEvent extends KycEvent {
  const EAuthSuccessEvent();
}

class CloseEAuthWebView extends KycEvent {
  const CloseEAuthWebView();
}
