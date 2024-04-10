import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/otp_bloc/otp_bloc.dart';
// Import your OtpState

void main() {
  group('OtpBloc', () {
    late OtpBloc otpBloc;

    setUp(() {
      otpBloc = OtpBloc();
    });

    tearDown(() {
      otpBloc.close();
    });

    test('Initial state is OtpInitial', () {
      expect(otpBloc.state, OtpInitial());
    });

    blocTest<OtpBloc, OtpState>(
      'emits [OtpValidState] when PhoneOtpVerifyEvent is added with a valid OTP',
      build: () => otpBloc,
      act: (bloc) => bloc.add(const PhoneOtpVerifyEvent(otp: '123456')),
      expect: () => [OtpValidState()],
    );

    blocTest<OtpBloc, OtpState>(
      'emits [OtpIncompleteState] when PhoneOtpVerifyEvent is added with an incomplete OTP',
      build: () => otpBloc,
      act: (bloc) => bloc.add(const PhoneOtpVerifyEvent(otp: '12345')),
      expect: () => [OtpIncompleteState()],
    );

    blocTest<OtpBloc, OtpState>(
      'emits [SendingOtpEventState] when SendOtpEvent is added',
      build: () => otpBloc,
      act: (bloc) => bloc.add(const SendOtpEvent()),
      expect: () => [SendingOtpEventState()],
    );

    // blocTest<OtpBloc, OtpState>(
    //   'updates phoneNumber when PhoneNumberSaveEvent is added',
    //   build: () => otpBloc,
    //   act: (bloc) =>
    //       bloc.add(const PhoneNumberSaveEvent(phoneNumber: '1234567890')),
    //   expect: () => [],
    //   verify: (bloc) {
    //     expect((bloc).phoneNumber, '1234567890');
    //   },
    // );
  });
}
