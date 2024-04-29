import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/on_boarding/domain/entities/e_auth_providers_entity.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/kyc_bloc/kyc_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
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
    'emits [KycLoadingState, ShowWebViewState] when UpdateUserKycEvent is added and getEAuthProviders is successful',
    build: () {
      when(mockOnBoardingUseCase.getEAuthProviders()).thenAnswer((_) async => EAuthProviderEntity(
          redirectUrl: 'https://example.com',
          code: "",
          subTitle: "",
          iconLink: "https://example.com",
          title: "example"));
      return kycBloc;
    },
    act: (bloc) => bloc.add(const UpdateUserKycEvent()),
    expect: () => [
      KycLoadingState(),
      const ShowWebViewState('https://example.com'),
    ],
  );

  blocTest<KycBloc, KycState>(
    'emits [KycLoadingState, KycFailedState] when UpdateUserKycEvent is added and getEAuthProviders returns null',
    build: () {
      when(mockOnBoardingUseCase.getEAuthProviders()).thenAnswer((_) async => null);
      return kycBloc;
    },
    act: (bloc) => bloc.add(const UpdateUserKycEvent()),
    expect: () => [
      KycLoadingState(),
      KycFailedState(),
    ],
  );

  blocTest<KycBloc, KycState>(
    'emits [KycLoadingState, KycErrorState] when UpdateUserKycEvent is added and getEAuthProviders throws an exception',
    build: () {
      when(mockOnBoardingUseCase.getEAuthProviders()).thenThrow(Exception('Error'));
      return kycBloc;
    },
    act: (bloc) => bloc.add(const UpdateUserKycEvent()),
    expect: () => [
      KycLoadingState(),
      const KycErrorState('Error'),
    ],
  );

  blocTest<KycBloc, KycState>(
    'emits [KycLoadingState, AuthorizedUserState] when EAuthSuccessEvent is added',
    build: () => kycBloc,
    act: (bloc) => bloc.add(const EAuthSuccessEvent()),
    expect: () => [
      KycLoadingState(),
      AuthorizedUserState(),
    ],
  );

  blocTest<KycBloc, KycState>(
    'emits [KycLoadingState, KycInitial] when CloseEAuthWebView is added',
    build: () => kycBloc,
    act: (bloc) => bloc.add(const CloseEAuthWebView()),
    expect: () => [
      KycLoadingState(),
      KycInitial(),
    ],
  );
}
