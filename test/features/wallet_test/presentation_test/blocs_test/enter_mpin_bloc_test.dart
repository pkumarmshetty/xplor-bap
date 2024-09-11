import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/presentation/blocs/enter_mpin_bloc/enter_mpin_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late EnterMPinBloc enterMPinBloc;
  late MockWalletUseCase mockWalletUseCase;

  setUp(() {
    mockWalletUseCase = MockWalletUseCase();
    enterMPinBloc = EnterMPinBloc(useCase: mockWalletUseCase);
  });

  tearDown(() {
    enterMPinBloc.close();
  });

  group('EnterMPinBloc', () {
    test('initial state is MPinInitial', () {
      expect(enterMPinBloc.state, equals(MPinInitial()));
    });

    blocTest<EnterMPinBloc, EnterMPinState>(
      'emits MPinValidState when MPinValidatorEvent is added with a valid MPIN',
      build: () => enterMPinBloc,
      act: (bloc) => bloc.add(const MPinValidatorEvent(mPIn: '123456')),
      expect: () => [MPinValidState()],
    );

    blocTest<EnterMPinBloc, EnterMPinState>(
      'emits MPinIncompleteState when MPinValidatorEvent is added with an incomplete MPIN',
      build: () => enterMPinBloc,
      act: (bloc) => bloc.add(const MPinValidatorEvent(mPIn: '123')),
      expect: () => [MPinIncompleteState()],
    );

    blocTest<EnterMPinBloc, EnterMPinState>(
      'emits SuccessMPinState when MPinVerifyEvent is added with correct MPIN',
      build: () {
        when(mockWalletUseCase.verifyMpin('123456')).thenAnswer((_) async => true);
        return enterMPinBloc;
      },
      act: (bloc) => bloc.add(const MPinVerifyEvent(mPin: '123456')),
      expect: () => [
        MPinLoadingState(),
        SuccessMPinState(),
      ],
    );
  });

  group('_onVerifyMPinFn', () {
    blocTest<EnterMPinBloc, EnterMPinState>(
      'emits [MPinLoadingState, SuccessMPinState] when useCase returns true',
      build: () {
        when(mockWalletUseCase.verifyMpin('123456')).thenAnswer((_) async => true);
        return enterMPinBloc;
      }, // Replace with your actual Bloc class
      act: (bloc) => bloc.add(const MPinVerifyEvent(mPin: '123456')),
      expect: () => [
        MPinLoadingState(),
        SuccessMPinState(),
      ],
    );

    blocTest<EnterMPinBloc, EnterMPinState>(
      'emits [MPinLoadingState, FailureMPinState] when useCase throws an error',
      build: () {
        when(mockWalletUseCase.verifyMpin('000000')).thenThrow(Exception('Invalid MPIN')); // Corrected argument
        return enterMPinBloc;
      },
      act: (bloc) => bloc.add(const MPinVerifyEvent(mPin: '000000')),
      expect: () => [
        MPinLoadingState(),
        // We expect a FailureMPinState with the appropriate error message
        const FailureMPinState('Invalid MPIN'),
        // Adjust the error message as needed
      ],
    );
  });
}
