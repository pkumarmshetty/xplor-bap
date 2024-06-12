import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xplor/features/wallet/domain/usecase/wallet_usecase.dart';

import '../../../../../utils/app_utils/app_utils.dart';

part 'enter_mpin_event.dart';

part 'enter_mpin_state.dart';

class EnterMPinBloc extends Bloc<EnterMPinEvent, EnterMPinState> {
  String? mpin;
  WalletUseCase useCase;

  EnterMPinBloc({required this.useCase}) : super(MPinInitial()) {
    on<MPinValidatorEvent>(_onVerifyValidMPin);
    on<MPinVerifyEvent>(_onVerifyMPinFn);
    on<MPinInitialEvent>(_onInitialEvent);
  }

  _onVerifyValidMPin(MPinValidatorEvent event, Emitter<EnterMPinState> emit) {
    if (event.mPIn.length == 6) {
      mpin = event.mPIn;
      emit(MPinValidState());
    } else if (event.mPIn.length < 6) {
      emit(MPinIncompleteState());
    }
  }

  _onVerifyMPinFn(MPinVerifyEvent event, Emitter<EnterMPinState> emit) async {
    /// emit loading state
    emit(MPinLoadingState());
    try {
      /// call verify mpin api
      bool success = await useCase.verifyMpin(event.mPin);

      ///emit success state if verify mpin is successful else emit failure state
      if (success) {
        emit(SuccessMPinState());
      }
      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(FailureMPinState(AppUtils.getErrorMessage(e.toString())));
      return false;
    }
  }

  FutureOr<void> _onInitialEvent(MPinInitialEvent event, Emitter<EnterMPinState> emit) {
    emit(MPinInitial());
  }
}
