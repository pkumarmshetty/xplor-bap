import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/const/app_state.dart';
import 'package:xplor/features/wallet/domain/entities/previous_consent_entity.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/my_consent_bloc/my_consent_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/my_consent_bloc/my_consent_event.dart';
import 'package:xplor/features/wallet/presentation/blocs/my_consent_bloc/my_consent_state.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWalletUseCase mockWalletUseCase;
  late MyConsentBloc myConsentBloc;

  const String exception = "Exception";

  var data = json.decode(readJson('features/wallet_test/helpers/json_responses/shared_vc_consent.json'));

  List<SharedVcDataEntity> sharedDataEntity = [];
  if (data['data'] != null) {
    sharedDataEntity = List<SharedVcDataEntity>.from(data['data'].map((data) => SharedVcDataEntity.fromJson(data)));
  }

  var previous = json.decode(readJson('features/wallet_test/helpers/json_responses/previous_data_entity_data.json'));

  List<PreviousConsentEntity> previousConsentEntity = [];
  if (previous['data'] != null) {
    previousConsentEntity =
        List<PreviousConsentEntity>.from(previous['data'].map((previous) => PreviousConsentEntity.fromJson(previous)));
  }

  setUp(() {
    mockWalletUseCase = MockWalletUseCase();
    myConsentBloc = MyConsentBloc(useCase: mockWalletUseCase);
  });

  tearDown(() {
    myConsentBloc.close();
  });

  test('emits [MyConsentInitial] when ShareDialogBloc is created', () {
    expect(myConsentBloc.state, MyConsentInitial());
  });

  blocTest<MyConsentBloc, MyConsentState>(
    'emits [MyConsentLoadingState, MyConsentLoadedState] when GetUserConsentEvent is added and fetch is successful',
    build: () {
      when(mockWalletUseCase.getMyConsents()).thenAnswer((_) async => sharedDataEntity);
      when(mockWalletUseCase.getMyPrevConsents()).thenAnswer((_) async => previousConsentEntity);
      return myConsentBloc;
    },
    act: (bloc) => bloc.add(const GetUserConsentEvent()),
    expect: () => [
      const MyConsentLoadingState(),
      MyConsentLoadedState(myConsents: sharedDataEntity, previousConsents: const [], status: AppPageStatus.success),
    ],
  );

  blocTest<MyConsentBloc, MyConsentState>(
    'emits [MyConsentLoadingState, MyConsentErrorState] when GetUserConsentEvent is added and fetch fails',
    build: () {
      when(mockWalletUseCase.getMyConsents()).thenThrow(Exception(exception));
      return myConsentBloc;
    },
    act: (bloc) => bloc.add(const GetUserConsentEvent()),
    expect: () => [
      const MyConsentLoadingState(),
      MyConsentErrorState(errorMessage: AppUtils.getErrorMessage(Exception(exception).toString())),
    ],
  );

  blocTest<MyConsentBloc, MyConsentState>(
    'emits [MyConsentLoadingState, MyConsentRevokeSuccessState] when ConsentRevokeEvent is added and revocation is successful',
    build: () {
      when(mockWalletUseCase.revokeConsent(any)).thenAnswer((_) async => true);
      return myConsentBloc;
    },
    act: (bloc) => bloc.add(ConsentRevokeEvent(entity: sharedDataEntity[0])),
    expect: () => [
      const MyConsentLoadingState(),
      MyConsentRevokeSuccessState(),
    ],
  );

  blocTest<MyConsentBloc, MyConsentState>(
    'emits [MyConsentLoadingState, MyConsentRevokeErrorState] when ConsentRevokeEvent is added and revocation fails',
    build: () {
      when(mockWalletUseCase.revokeConsent(any)).thenThrow(Exception(exception));
      return myConsentBloc;
    },
    act: (bloc) => bloc.add(ConsentRevokeEvent(entity: sharedDataEntity[0])),
    expect: () => [
      const MyConsentLoadingState(),
      MyConsentRevokeErrorState(errorMessage: Exception(exception).toString()),
    ],
  );
}
