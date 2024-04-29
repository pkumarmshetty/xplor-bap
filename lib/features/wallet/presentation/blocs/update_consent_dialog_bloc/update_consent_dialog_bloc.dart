import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_event.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_state.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/usecase/wallet_usecase.dart';

class UpdateConsentDialogBloc extends Bloc<UpdateConsentDialogEvent, UpdateConsentDialogState> {
  WalletUseCase useCase;

  UpdateConsentDialogBloc({required this.useCase}) : super(UpdateConsentDialogInitial()) {
    on<ConsentUpdateDialogUpdatedEvent>(_handleUpdateEvent);
    on<ConsentUpdateDialogSubmittedEvent>(_handleSubmitEvent);
  }

  _handleUpdateEvent(ConsentUpdateDialogUpdatedEvent event, Emitter<UpdateConsentDialogState> emit) async {
    if (state is UpdateConsentDialogInitial) {
      emit(ConsentUpdateDialogUpdatedState(selectedItem: event.selectedItem ?? 1, inputText: event.remarks ?? ''));
    } else {
      if (kDebugMode) {
        print('abccc');
      }
      emit((state as ConsentUpdateDialogUpdatedState).copyWith(selectedItem: event.selectedItem, text: event.remarks));
      /*emit(ConsentUpdateDialogUpdatedState(
          selectedItem: event.selectedItem ?? 1,
          inputText: event.remarks ?? ''));*/
    }
  }

  _handleSubmitEvent(ConsentUpdateDialogSubmittedEvent event, Emitter<UpdateConsentDialogState> emit) async {
    /*emit(ConsentUpdateDialogUpdatedState(
        selectedItem: event.selectedItem, inputText: event.remarks));*/
    //emit(const MyConsentLoadingState());
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
