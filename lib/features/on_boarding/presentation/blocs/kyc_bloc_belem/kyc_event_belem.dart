part of 'kyc_bloc_belem.dart';

sealed class KycEventBelem extends Equatable {
  const KycEventBelem();

  @override
  List<Object> get props => [];
}

class GetProvidersEvent extends KycEventBelem {
  const GetProvidersEvent();
}

class OpenWebViewEvent extends KycEventBelem {
  final String redirectUrl;
  const OpenWebViewEvent({required this.redirectUrl});
  @override
  List<Object> get props => [redirectUrl];
}

class InitSseKycEvent extends KycEventBelem {
  const InitSseKycEvent();
}

class KycSseFailureEvent extends KycEventBelem {
  final String error;

  const KycSseFailureEvent({required this.error});
}

class EAuthSuccessEvent extends KycEventBelem {
  const EAuthSuccessEvent();
}

class UpdateLoaderEvent extends KycEventBelem {
  final bool loader;

  const UpdateLoaderEvent({this.loader = false});
}

class EAuthFailureEvent extends KycEventBelem {
  const EAuthFailureEvent();
}

class CloseEAuthWebView extends KycEventBelem {
  const CloseEAuthWebView();
}

class ShowKycLoadingEvent extends KycEventBelem {
  const ShowKycLoadingEvent();
}
