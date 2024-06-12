part of 'reset_mpin_bloc.dart';

enum MpinState { initial, completed, misMatched, failure, success }

enum OtpState { inComplete, completed, failure, success }

abstract class ResetMpinState extends Equatable {
  const ResetMpinState();
}

class ResetMpinInitial extends ResetMpinState {
  @override
  List<Object> get props => [];
}

class ResetMpinUpdatedState extends ResetMpinState {
  final OtpState otpState;
  final MpinState mpinState;
  final bool isLoading;
  final String otpErrorMessage;
  final String mpinErrorMessage;

  @override
  List<Object> get props => [otpState, mpinState, otpErrorMessage, mpinErrorMessage, isLoading];

  const ResetMpinUpdatedState({
    required this.isLoading,
    required this.otpState,
    required this.mpinState,
    this.mpinErrorMessage = "",
    this.otpErrorMessage = "",
  });

  ResetMpinUpdatedState copyWith({
    bool? isLoading,
    OtpState? otpState,
    MpinState? mpinState,
    String? otpErrorMessage,
    String? mpinErrorMessage,
  }) {
    return ResetMpinUpdatedState(
      isLoading: isLoading ?? this.isLoading,
      otpState: otpState ?? this.otpState,
      mpinState: mpinState ?? this.mpinState,
      otpErrorMessage: otpErrorMessage ?? this.otpErrorMessage,
      mpinErrorMessage: mpinErrorMessage ?? this.mpinErrorMessage,
    );
  }
}

// class ResetMpinCompletedState extends ResetMpinState {
//   @override
//   List<Object> get props => [];
// }
//
// class ResetOtpSuccessState extends ResetMpinState {
//   @override
//   List<Object> get props => [];
// }

// class ResetMpinSuccessState extends ResetMpinState {
//   @override
//   List<Object> get props => [];
// }

// class OtpCompletedState extends ResetMpinState {
//   @override
//   List<Object> get props => [];
// }

// class ResetMpinsMismatchedState extends ResetMpinState {
//   final String errorMessage;
//
//   @override
//   List<Object> get props => [];
//
//   const ResetMpinsMismatchedState({
//     required this.errorMessage,
//   });
// }

// class ResetMpinFailureState extends ResetMpinState {
//   final String errorMessage;
//
//
//   @override
//   List<Object> get props => [];
//
//   const ResetMpinFailureState({
//     required this.errorMessage,
//   });
// }
