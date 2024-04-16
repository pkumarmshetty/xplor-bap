import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/on_boarding/domain/usecase/on_boarding_usecase.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/kyc_bloc/kyc_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  group('KycBloc', () {
    late KycBloc kycBloc;
    late MockOnBoardingUseCase mockOnBoardingUseCase;

    setUp(() {
      mockOnBoardingUseCase = MockOnBoardingUseCase();
      kycBloc = KycBloc(useCase: mockOnBoardingUseCase);
    });

    tearDown(() {
      kycBloc.close();
    });

    test('initial state is KycInitial', () {
      expect(kycBloc.state, KycInitial());
    });

    blocTest<KycBloc, KycState>(
      'emits KycLoadingState followed by KycSuccessState when updateUserKycOnBoarding succeeds',
      build: () {
        when(mockOnBoardingUseCase.updateUserKycOnBoarding())
            .thenAnswer((_) async => true);
        return kycBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserKycEvent()),
      expect: () => [
        KycLoadingState(),
        KycSuccessState(),
      ],
    );

    blocTest<KycBloc, KycState>(
      'emits KycLoadingState followed by KycFailedState when updateUserKycOnBoarding fails',
      build: () {
        GetIt.I.registerSingleton<OnBoardingUseCase>(mockOnBoardingUseCase);
        when(mockOnBoardingUseCase.updateUserKycOnBoarding())
            .thenAnswer((_) async => false);
        return kycBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserKycEvent()),
      expect: () => [
        KycLoadingState(),
        KycFailedState(),
      ],
    );

    blocTest<KycBloc, KycState>(
      'emits KycLoadingState followed by KycErrorState when updateUserKycOnBoarding throws an error',
      build: () {
        when(mockOnBoardingUseCase.updateUserKycOnBoarding())
            .thenAnswer((_) => Future.error('Error'));
        return kycBloc;
      },
      act: (bloc) => bloc.add(const UpdateUserKycEvent()),
      expect: () => [
        KycLoadingState(),
        isA<KycErrorState>(),
      ],
    );
  });
}
