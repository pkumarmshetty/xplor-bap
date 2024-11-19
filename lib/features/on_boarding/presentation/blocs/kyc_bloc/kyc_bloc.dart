import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import '../../../domain/usecase/on_boarding_usecase.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../core/exception_errors.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/entities/e_auth_providers_entity.dart';

part 'kyc_event.dart';

part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  OnBoardingUseCase useCase;

  EAuthProviderEntity? entity;

  KycBloc({required this.useCase}) : super(KycInitial()) {
    /// call _onUpdateUserKycSubmit on UpdateUserKycEvent
    on<GetProvidersEvent>(_getEAuthProviders);
    on<EAuthSuccessEvent>(authorize);
    on<CloseEAuthWebView>(closeEAuthWebView);
    on<EAuthFailureEvent>(authorizationFail);
    on<InitSseKycEvent>(initSseKycEvent);
    on<KycSseFailureEvent>(_failureState);
    on<OpenWebViewEvent>(_openWebViewEvent);

    /// This code is commented for future reference
    //on<UpdateUserKycEvent>(_onUpdateUserKycSubmit);
  }

  Future<bool> closeEAuthWebView(CloseEAuthWebView event, Emitter<KycState> emit) async {
    /// emit loading state
    emit(KycLoadingState());
    try {
      emit(KycInitial());
      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(KycErrorState(e.toString()));
      return false;
    }
  }

  Future<void> _failureState(KycSseFailureEvent event, Emitter<KycState> emit) async {
    emit(KycErrorState(event.error));
    add(const EAuthFailureEvent());
  }

  Future<bool> authorize(EAuthSuccessEvent event, Emitter<KycState> emit) async {
    /// emit loading state
    emit(KycLoadingState());
    try {
      emit(AuthorizedUserState());

      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(KycErrorState(e.toString()));
      return false;
    }
  }

  Future<bool> authorizationFail(EAuthFailureEvent event, Emitter<KycState> emit) async {
    /// emit loading state
    emit(KycLoadingState());
    try {
      emit(KycFailedState());
      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(KycErrorState(e.toString()));
      return false;
    }
  }

  Future<void> initSseKycEvent(InitSseKycEvent event, Emitter<KycState> emit) async {
    emit(KycWebLoadingState());
    final sseStream = useCase.getKycSuccessStatusResponse(const Duration(minutes: 1));

    sseStream.listen((event) {
      if (event.kycStatus) {
        SSEClient.unsubscribeFromSSE();
        add(const EAuthSuccessEvent());
      } else {
        add(const EAuthFailureEvent());
      }
    }, onError: (error) {
      // Handle error
      AppUtils.printLogs('Error occurred: $error');

      var message = AppUtils.getErrorMessage(error.toString());

      if (message.toString().startsWith('ClientException with SocketNetwork')) {
        message = ExceptionErrors.checkInternetConnection.stringToString;
      }

      add(KycSseFailureEvent(error: message));
    });
  }

  /// Handles the update user kyc submit event.
  Future<bool> _getEAuthProviders(GetProvidersEvent event, Emitter<KycState> emit) async {
    /// emit loading state
    emit(AuthProviderLoadingState());
    try {
      /// call getEAuthProviders api
      EAuthProviderEntity? provider = await useCase.getEAuthProviders();
      entity = provider;
      if (provider != null) {
        emit(AuthProviderLoadedState(data: provider));
      } else {
        emit(KycFailedState());
      }

      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(KycErrorState(e.toString()));
      return false;
    }
  }

  /// Handles the update user kyc submit event.
  /// This code is commented for future reference
/*Future<bool> _onUpdateUserKycSubmit(
      UpdateUserKycEvent event, Emitter<KycState> emit) async {
    /// emit loading state
    emit(KycLoadingState());
    try {
      /// call updateUserKyc api
      bool success = await useCase.updateUserKycOnBoarding();

      ///emit success state if KYC verification is successful else emit failure state
      success ? emit(KycSuccessState()) : emit(KycFailedState());
      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(KycErrorState(e.toString()));
      return false;
    }
  }*/

  FutureOr<void> _openWebViewEvent(OpenWebViewEvent event, Emitter<KycState> emit) {
    emit(ShowWebViewState(requestUrl: event.redirectUrl));
  }
}
