import 'package:bloc/bloc.dart';
import 'update_consent_dialog_event.dart';
import 'update_consent_dialog_state.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/usecase/wallet_usecase.dart';

/// Bloc responsible for managing user consents.
class UpdateConsentDialogBloc extends Bloc<UpdateConsentDialogEvent, UpdateConsentDialogState> {
  WalletUseCase useCase;

  UpdateConsentDialogBloc({required this.useCase}) : super(UpdateConsentDialogInitial()) {
    on<ConsentUpdateDialogUpdatedEvent>(_handleUpdateEvent);
    on<ConsentUpdateDialogSubmittedEvent>(_handleSubmitEvent);
  }

  /// Event handler for updating user consents.
  _handleUpdateEvent(ConsentUpdateDialogUpdatedEvent event, Emitter<UpdateConsentDialogState> emit) async {
    if (state is UpdateConsentDialogInitial) {
      emit(ConsentUpdateDialogUpdatedState(selectedItem: event.selectedItem ?? 1, inputText: event.remarks ?? ''));
    } else {
      AppUtils.printLogs('abccc');
      emit((state as ConsentUpdateDialogUpdatedState).copyWith(selectedItem: event.selectedItem, text: event.remarks));
    }
  }

  /// Event handler for submitting user consents.
  _handleSubmitEvent(ConsentUpdateDialogSubmittedEvent event, Emitter<UpdateConsentDialogState> emit) async {
    try {
      emit(MyConsentLoaderState());
      final success = await useCase.updateConsent(event.updateConsent, event.requestId);
      if (success) {
        // Add NavigationEvent if successful
        emit(MyConsentUpdateSuccessState());
        emit(UpdateConsentDialogInitial());
      } else {
        throw Exception();
      }
    } catch (e) {
      emit(MyConsentUpdateErrorState(errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }
}
