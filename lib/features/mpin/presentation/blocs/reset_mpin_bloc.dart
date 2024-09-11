import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../domain/entities/send_mpin_otp_entity.dart';
import '../../domain/usecase/mpin_usecase.dart';
import '../../../../utils/app_utils/app_utils.dart';

part 'reset_mpin_event.dart';
part 'reset_mpin_state.dart';

class ResetMpinBloc extends Bloc<ResetMpinEvent, ResetMpinState> {
  MpinUseCase useCase;

  ResetMpinBloc({required this.useCase}) : super(ResetMpinInitial()) {
    on<MpinOtpChangedEvent>(_onOtpChangedEvent);
    on<VerifyOtpEvent>(_onVerifyOtpEvent);
    on<ResetMpinChangedEvent>(_onMpinChangedEvent);
    on<ResetMpinApiEvent>(_onResetMpinApiEvent);
    on<ResetMpinOtpEvent>(_onResetMpinOtpEvent);
  }

  String mpinKey = '';
  // String mpinOtp = '';
  String verifiedMpinKey = '';

  _onResetMpinOtpEvent(ResetMpinOtpEvent event, Emitter<ResetMpinState> emit) async {
    if (state is ResetMpinInitial) {
      emit(const ResetMpinUpdatedState(
          isLoading: true,
          otpState: OtpState.inComplete,
          mpinState: MpinState.initial,
          mpinErrorMessage: '',
          otpErrorMessage: ''));
    } else {
      emit((state as ResetMpinUpdatedState).copyWith(
          isLoading: true,
          otpState: OtpState.inComplete,
          mpinState: MpinState.initial,
          mpinErrorMessage: '',
          otpErrorMessage: ''));
    }
    try {
      SendResetMpinOtpEntity res = await useCase.sendResetMpinOtp();
      mpinKey = res.mpinKey ?? '';
      emit((state as ResetMpinUpdatedState).copyWith(
        isLoading: false,
      ));
    } catch (e) {
      emit((state as ResetMpinUpdatedState).copyWith(
          otpState: OtpState.failure, isLoading: false, otpErrorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  _onOtpChangedEvent(MpinOtpChangedEvent event, Emitter<ResetMpinState> emit) {
    if (event.otp.length == 6) {
      emit((state as ResetMpinUpdatedState).copyWith(otpState: OtpState.completed, mpinState: MpinState.initial));
    } else {
      emit((state as ResetMpinUpdatedState).copyWith(otpState: OtpState.inComplete, mpinState: MpinState.initial));
    }
  }

  _onVerifyOtpEvent(VerifyOtpEvent event, Emitter<ResetMpinState> emit) async {
    if (event.otp.length == 6) {
      emit((state as ResetMpinUpdatedState).copyWith(
        isLoading: true,
      ));
      try {
        String verifiedKey = await useCase.verifyMpinOtp(SendResetMpinOtpEntity(mpinKey: mpinKey, otp: event.otp));
        verifiedMpinKey = verifiedKey;
        emit((state as ResetMpinUpdatedState).copyWith(
          isLoading: false,
          otpState: OtpState.success,
        ));
      } catch (e) {
        emit((state as ResetMpinUpdatedState).copyWith(
            otpState: OtpState.failure, isLoading: false, otpErrorMessage: AppUtils.getErrorMessage(e.toString())));
      }
    }
  }

  _onResetMpinApiEvent(ResetMpinApiEvent event, Emitter<ResetMpinState> emit) async {
    if (event.pin1.length == 6 && event.pin1 == event.pin2) {
      emit((state as ResetMpinUpdatedState).copyWith(isLoading: true));
      try {
        await useCase.resetMpin(verifiedMpinKey, event.pin1);
        emit((state as ResetMpinUpdatedState).copyWith(
          isLoading: false,
          mpinState: MpinState.success,
        ));
      } catch (e) {
        emit((state as ResetMpinUpdatedState).copyWith(
            mpinState: MpinState.failure, isLoading: false, mpinErrorMessage: AppUtils.getErrorMessage(e.toString())));
      }
    } else if (state is ResetMpinUpdatedState && event.pin1 != event.pin2) {
      emit((state as ResetMpinUpdatedState)
          .copyWith(mpinState: MpinState.failure, mpinErrorMessage: GenerateMpinKeys.pinDonMatch.stringToString));
    } else if (state is ResetMpinUpdatedState && event.pin1 != event.pin2) {
      emit((state as ResetMpinUpdatedState)
          .copyWith(mpinState: MpinState.failure, mpinErrorMessage: GenerateMpinKeys.pinDonMatch.stringToString));
    }
  }

  _onMpinChangedEvent(ResetMpinChangedEvent event, Emitter<ResetMpinState> emit) {
    if (event.confirmPin.length == 6 && event.originalPin.length == 6) {
      if (state is ResetMpinUpdatedState) {
        emit((state as ResetMpinUpdatedState).copyWith(
          mpinState: MpinState.completed,
        ));
      }
    } else {
      emit((state as ResetMpinUpdatedState).copyWith(mpinState: MpinState.initial));
    }
  }
}
