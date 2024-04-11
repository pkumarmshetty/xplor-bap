import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xplor/core/dependency_injection.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  KycBloc() : super(KycInitial()) {
    /// call _onUpdateUserKycSubmit on UpdateUserKycEvent
    on<UpdateUserKycEvent>(_onUpdateUserKycSubmit);
  }

  /// Handles the update user kyc submit event.
  Future<bool> _onUpdateUserKycSubmit(UpdateUserKycEvent event, Emitter<KycState> emit) async {
    /// emit loading state
    emit(KycLoadingState());
    try {
      /// call updateUserKyc api
      bool success = await sl<OnBoardingUseCase>().updateUserKycOnBoarding();

      ///emit success state if KYC verification is successful else emit failure state
      success ? emit(KycSuccessState()) : emit(KycFailedState());
      return true;
    } catch (e) {
      /// emit error state for any error encountered
      emit(KycErrorState(e.toString()));
      return false;
    }
  }
}
