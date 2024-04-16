import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/on_boarding/domain/entities/ob_boarding_verify_otp_entity.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/otp_bloc/otp_bloc.dart';

import '../../helpers/test_helper.mocks.dart';
// Import your OtpState

void main() {
  group('OtpBloc', () {
    late OtpBloc otpBloc;
    late MockOnBoardingUseCase mockOnBoardingUseCase;

    setUp(() {
      mockOnBoardingUseCase = MockOnBoardingUseCase();
      otpBloc = OtpBloc(useCase: mockOnBoardingUseCase);
    });

    tearDown(() {
      otpBloc.close();
    });

    test('Initial state is OtpInitial', () {
      expect(otpBloc.state, OtpInitial());
    });

    blocTest<OtpBloc, OtpState>(
      'emits OtpValidState when a valid OTP is provided',
      build: () => otpBloc,
      act: (bloc) {
        bloc.add(const PhoneOtpValidatorEvent(otp: '123456'));
      },
      expect: () => [OtpValidState()],
    );

    blocTest<OtpBloc, OtpState>(
      'emits OtpIncompleteState when an incomplete OTP is provided',
      build: () => otpBloc,
      act: (bloc) {
        bloc.add(const PhoneOtpValidatorEvent(otp: '1234'));
      },
      expect: () => [OtpIncompleteState()],
    );

    OnBoardingVerifyOtpEntity entity =
        OnBoardingVerifyOtpEntity(otp: "123456", key: "r234324234");

    blocTest<OtpBloc, OtpState>(
      'emits SuccessOtpState when OTP verification is successful',
      build: () {
        when(mockOnBoardingUseCase.verifyOtpOnBoarding(entity))
            .thenAnswer((_) async {});
        return otpBloc;
      },
      act: (bloc) {
        bloc.add(const PhoneOtpVerifyEvent(otp: '123456'));
      },
      expect: () => [
        OtpLoadingState(),
        SuccessOtpState(),
      ],
    );
    var phoneNumberData = "+91 909 090 9090";
    OnBoardingSendOtpEntity phoneEntity =
        OnBoardingSendOtpEntity(phoneNumber: '+91 909 090 9090');

    blocTest<OtpBloc, OtpState>(
      'emits ResendOtpSubmitted when resend OTP is successful',
      build: () {
        when(mockOnBoardingUseCase.call(params: anyNamed('params')))
            .thenAnswer((_) async => 'resend_key');
        return otpBloc;
      },
      act: (bloc) {
        bloc.add(SendOtpEvent(phoneNumber: phoneNumberData));
      },
      expect: () => [
        OtpLoadingState(),
        ResendOtpSubmitted(),
      ],
    );

    blocTest<OtpBloc, OtpState>(
      'emits FailureOtpState when resend OTP fails',
      build: () {
        when(mockOnBoardingUseCase.call(params: phoneEntity))
            .thenThrow(Exception());
        return otpBloc;
      },
      act: (bloc) {
        bloc.add(const SendOtpEvent());
      },
      expect: () => [
        OtpLoadingState(),
        isA<FailureOtpState>(),
      ],
    );

    blocTest<OtpBloc, OtpState>(
      'emits SuccessOtpState when user journey is successfully fetched',
      build: () {
        when(mockOnBoardingUseCase.getUserJourney())
            .thenAnswer((_) async => 'success');
        return otpBloc;
      },
      act: (bloc) {
        bloc.add(const GetUserJourneyEvent());
      },
      expect: () => [
        OtpLoadingState(),
        SuccessOtpState(),
      ],
    );

    blocTest<OtpBloc, OtpState>(
      'emits FailureOtpState when user journey fetch fails',
      build: () {
        when(mockOnBoardingUseCase.getUserJourney()).thenThrow(Exception());
        return otpBloc;
      },
      act: (bloc) {
        bloc.add(const GetUserJourneyEvent());
      },
      expect: () => [
        OtpLoadingState(),
        isA<FailureOtpState>(),
      ],
    );

    blocTest<OtpBloc, OtpState>(
      'emits FailureOtpState when OTP verification fails',
      build: () {
        when(mockOnBoardingUseCase.verifyOtpOnBoarding(any))
            .thenThrow(Exception());
        return otpBloc;
      },
      act: (bloc) {
        bloc.add(const PhoneOtpVerifyEvent(otp: '1234454666'));
      },
      expect: () => [
        OtpLoadingState(),
        const FailureOtpState('Exception'),
      ],
    );
  });
}
