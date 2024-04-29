import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';

import '../../../../../utils/app_utils/app_utils.dart';

part 'mpin_event.dart';
part 'mpin_state.dart';

class MpinBloc extends Bloc<MpinEvent, MpinState> {
  OnBoardingUseCase useCase;
  MpinBloc({required this.useCase}) : super(const MpinInitial()) {
    on<PinChangedEvent>(_onOriginalPinInput);
    on<ConfirmPinChangedEvent>(_onConfirmPinInput);
    on<ValidatePinsEvent>(_onValidatePin);
  }
  _onOriginalPinInput(PinChangedEvent event, Emitter<MpinState> emit) {
    if (event.originalPin.length == 6 && event.confirmPin.length == 6) {
      emit(const PinCompletedState());
    } else {
      emit(const MpinInitial());
    }
  }

  _onConfirmPinInput(ConfirmPinChangedEvent event, Emitter<MpinState> emit) {
    emit(ConfirmPinUpdatedState(pin: event.pin));
  }

  _onValidatePin(ValidatePinsEvent event, Emitter<MpinState> emit) async {
    if (event.originalPin == event.confirmPin) {
      await _executeGenerateMpin(event.confirmPin, emit);
    } else {
      emit(const PinsMisMatchedState(
          errorMessage: 'The PINs you entered do not match. Please ensure that both PINs match before proceeding.'));
    }
  }

  /// call the create user mpin through api.
  Future<bool> _executeGenerateMpin(String pin, Emitter<MpinState> emit) async {
    /// emit loading state
    emit(const PinsLoadingState());
    try {
      /// call generate mpin api
      bool success = await useCase.createMpin(pin);

      ///emit success state if create mpin is successful else emit failure state
      if (success) {
        emit(PinSuccessState(pin));
      }
      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(PinFailedState(errorMessage: AppUtils.getErrorMessage(e.toString())));
      return false;
    }
  }
}
