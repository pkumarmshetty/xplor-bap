part of 'kyc_bloc.dart';

class KycState extends Equatable {
  const KycState();

  @override
  List<Object> get props => [];
}

final class KycInitial extends KycState {}

class KycSuccessState extends KycState {}

class KycLoadingState extends KycState {}

class WebLoadingState extends KycState {}

class KycWebLoadingState extends KycState {}

class ShowWebViewState extends KycState {
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

class KycErrorState extends KycState {
  const KycErrorState(this.error);

  final String error;
}

class AuthorizedUserState extends KycState {}

class KycFailedState extends KycState {}

class SuccessState extends KycState {}

final class AuthProviderLoadedState extends KycState {
  final EAuthProviderEntity data;

  const AuthProviderLoadedState({required this.data});

  @override
  List<Object> get props => [data];
}

class AuthProviderLoadingState extends KycState {}
