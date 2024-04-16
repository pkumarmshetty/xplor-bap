import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/on_boarding/domain/entities/on_boarding_send_otp_entity.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/phone_bloc/phone_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  group('PhoneBloc', () {
    late PhoneBloc phoneBloc;
    late MockOnBoardingUseCase mockOnBoardingUseCase;

    setUp(() {
      mockOnBoardingUseCase = MockOnBoardingUseCase();
      phoneBloc = PhoneBloc(useCase: mockOnBoardingUseCase);
    });

    tearDown(() {
      phoneBloc.close();
    });

    test('Initial state is PhoneInitial', () {
      expect(phoneBloc.state, PhoneInitial());
    });

    blocTest<PhoneBloc, PhoneState>(
      'emits [PhoneValidState] when CheckPhoneEvent is added with a valid phone number',
      build: () => phoneBloc,
      act: (bloc) => bloc.add(const CheckPhoneEvent(phone: '+918234567890')),
      expect: () => [PhoneValidState()],
    );

    blocTest<PhoneBloc, PhoneState>(
      'emits PhoneInvalidState when phone number is invalid',
      build: () => phoneBloc,
      act: (bloc) {
        bloc.add(
            const CheckPhoneEvent(phone: '0000000')); // An empty phone number
      },
      expect: () => [
        PhoneInvalidState(),
      ],
    );

    OnBoardingSendOtpEntity phoneEntity =
        OnBoardingSendOtpEntity(phoneNumber: '+91 909 090 9090');

    blocTest<PhoneBloc, PhoneState>(
      'emits correct state when country code is changed',
      build: () => phoneBloc,
      act: (bloc) {
        bloc.add(const CountryCodeEvent(countryCode: '+91'));
      },
      expect: () => [],
    );

    blocTest<PhoneBloc, PhoneState>(
      'emits FailurePhoneState when form submission fails',
      build: () => phoneBloc,
      act: (bloc) {
        when(mockOnBoardingUseCase.call(params: phoneEntity))
            .thenThrow(Exception());
        bloc.add(const PhoneSubmitEvent(phone: '+213 8234567890'));
      },
      expect: () => [
        PhoneLoadingState(),
        isA<FailurePhoneState>(),
      ],
    );

    var phoneNumberData = "+91 909 090 9090";

    blocTest<PhoneBloc, PhoneState>(
      'emits SuccessPhoneState when form is submitted with valid data',
      build: () {
        when(mockOnBoardingUseCase.call(params: anyNamed('params')))
            .thenAnswer((_) async => 'k9898988898989324');
        return phoneBloc;
      },
      act: (bloc) => bloc.add(PhoneSubmitEvent(phone: phoneNumberData)),
      expect: () => [
        PhoneLoadingState(),
        SuccessPhoneState(
            phoneNumber: phoneNumberData, key: 'k9898988898989324'),
      ],
      verify: (bloc) {
        // Correctly verify the method call with named parameters
        verify(mockOnBoardingUseCase.call(params: anyNamed('params')))
            .called(1);
      },
    );
  });
}
