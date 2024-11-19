part of 'kyc_bloc_belem.dart';

class KycStateBelem extends Equatable {
  const KycStateBelem();

  @override
  List<Object> get props => [];
}

final class KycInitial extends KycStateBelem {}

final class AuthProviderLoadedState extends KycStateBelem {
  final EAuthProviderEntity data;

  const AuthProviderLoadedState({required this.data});

  @override
  List<Object> get props => [data];
}

class AuthProviderLoadingState extends KycStateBelem {}

class KycSuccessState extends KycStateBelem {}

class KycLoadingState extends KycStateBelem {}

class WebLoadingState extends KycStateBelem {}

class KycWebLoadingState extends KycStateBelem {}

class ShowWebViewState extends KycStateBelem {
  final String? requestUrl;
  final bool loaderStatus;

  const ShowWebViewState({this.requestUrl, this.loaderStatus = false});

  ShowWebViewState copyWith({
    String? requestUrl,
    bool? loaderStatus,
  }) {
    return ShowWebViewState(
      requestUrl: requestUrl ?? this.requestUrl,
      loaderStatus: loaderStatus ?? this.loaderStatus,
    );
  }
}

class KycErrorState extends KycStateBelem {
  const KycErrorState(this.error);

  final String error;
}

class AuthorizedUserState extends KycStateBelem {}

class KycFailedState extends KycStateBelem {}

class SuccessState extends KycStateBelem {}
