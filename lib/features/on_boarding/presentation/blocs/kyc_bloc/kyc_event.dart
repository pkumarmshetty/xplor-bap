part of 'kyc_bloc.dart';

sealed class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object> get props => [];
}

class GetProvidersEvent extends KycEvent {
  const GetProvidersEvent();
}

class InitSseKycEvent extends KycEvent {
  const InitSseKycEvent();
}

class KycSseFailureEvent extends KycEvent {
  final String error;

  const KycSseFailureEvent({required this.error});
}

class EAuthSuccessEvent extends KycEvent {
  const EAuthSuccessEvent();
}

class UpdateLoaderEvent extends KycEvent {
  final bool loader;

  const UpdateLoaderEvent({this.loader = false});
}

class EAuthFailureEvent extends KycEvent {
  const EAuthFailureEvent();
}

class CloseEAuthWebView extends KycEvent {
  const CloseEAuthWebView();
}

class OpenWebViewEvent extends KycEvent {
  final String redirectUrl;
  const OpenWebViewEvent({required this.redirectUrl});
  @override
  List<Object> get props => [redirectUrl];
}
