import 'package:bloc/bloc.dart';

import '../../../../../const/app_state.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/usecase/wallet_usecase.dart';
import 'my_consent_event.dart';
import 'my_consent_state.dart';

class MyConsentBloc extends Bloc<MyConsentEvent, MyConsentState> {
  WalletUseCase useCase;

  MyConsentBloc({required this.useCase}) : super(MyConsentInitial()) {
    on<GetUserConsentEvent>(_onGetUserConsentEvent);
    on<ConsentRevokeEvent>(_onConsentRevokeEvent);
  }

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
