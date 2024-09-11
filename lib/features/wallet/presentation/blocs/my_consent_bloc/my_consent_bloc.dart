import 'package:bloc/bloc.dart';

import '../../../../../const/app_state.dart'; // Importing necessary dependencies
import '../../../../../utils/app_utils/app_utils.dart'; // Importing necessary dependencies
import '../../../domain/usecase/wallet_usecase.dart'; // Importing necessary dependencies
import 'my_consent_event.dart'; // Importing necessary dependencies
import 'my_consent_state.dart'; // Importing necessary dependencies

/// Bloc responsible for managing user consents.
class MyConsentBloc extends Bloc<MyConsentEvent, MyConsentState> {
  WalletUseCase useCase; // Instance of WalletUseCase for handling business logic

  MyConsentBloc({required this.useCase}) : super(MyConsentInitial()) {
    // Constructor initializes the bloc with MyConsentInitial state and registers event handlers
    on<GetUserConsentEvent>(_onGetUserConsentEvent); // Handles fetching user consents
    on<ConsentRevokeEvent>(_onConsentRevokeEvent); // Handles revoking consent
  }

  /// Event handler for fetching user consents.
  Future<void> _onGetUserConsentEvent(
    GetUserConsentEvent event,
    Emitter<MyConsentState> emit,
  ) async {
    emit(const MyConsentLoadingState());
    try {
      final myConsents = await useCase.getMyConsents();
      final previousConsents = await useCase.getMyPrevConsents();
      emit(MyConsentLoadedState(
          myConsents: myConsents, previousConsents: previousConsents, status: AppPageStatus.success));
    } catch (e) {
      emit(MyConsentErrorState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Event handler for revoking user consents.
  Future<void> _onConsentRevokeEvent(ConsentRevokeEvent event, Emitter<MyConsentState> emit) async {
    emit(const MyConsentLoadingState());
    try {
      final success = await useCase.revokeConsent(event.entity);
      if (success) {
        emit(MyConsentRevokeSuccessState());
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(MyConsentRevokeErrorState(errorMessage: e.toString()));
    }
  }
}
