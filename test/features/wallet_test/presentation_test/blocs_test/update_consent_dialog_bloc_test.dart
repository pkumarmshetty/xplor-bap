import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/domain/entities/update_consent_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_event.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_state.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late UpdateConsentDialogBloc updateConsentDialogBloc;
  late MockWalletUseCase mockWalletUseCase;
  String remarks = "Updated Remarks";
  String exception = "Exception";
  String requestId = "requestId_7267236182368123";
  UpdateConsentEntity entity = UpdateConsentEntity(
      remarks: remarks,
      restrictions: ConsentRestrictions(expiresIn: AppUtils.getHoursAccordingToDaySelection(2), viewOnce: false));

  setUp(() {
    mockWalletUseCase = MockWalletUseCase();
    updateConsentDialogBloc = UpdateConsentDialogBloc(useCase: mockWalletUseCase);
  });

  tearDown(() {
    updateConsentDialogBloc.close();
  });

  blocTest<UpdateConsentDialogBloc, UpdateConsentDialogState>(
    'emits [ConsentUpdateDialogUpdatedState] with updated selectedItem and inputText when ConsentUpdateDialogUpdatedEvent is added',
    build: () => updateConsentDialogBloc,
    act: (bloc) => bloc.add(ConsentUpdateDialogUpdatedEvent(selectedItem: 2, remarks: remarks)),
    expect: () => [
      ConsentUpdateDialogUpdatedState(selectedItem: 2, inputText: remarks),
    ],
  );

  blocTest<UpdateConsentDialogBloc, UpdateConsentDialogState>(
    'emits [MyConsentUpdateSuccessState, UpdateConsentDialogInitial] when ConsentUpdateDialogSubmittedEvent is added and update is successful',
    build: () {
      when(mockWalletUseCase.updateConsent(entity, requestId)).thenAnswer((_) async => true);
      return updateConsentDialogBloc;
    },
    act: (bloc) => bloc.add(ConsentUpdateDialogSubmittedEvent(updateConsent: entity, requestId: requestId)),
    expect: () => [
      MyConsentLoaderState(),
      MyConsentUpdateSuccessState(),
      UpdateConsentDialogInitial(),
    ],
  );

  blocTest<UpdateConsentDialogBloc, UpdateConsentDialogState>(
    'emits [MyConsentUpdateErrorState] when ConsentUpdateDialogSubmittedEvent is added and update fails',
    build: () {
      when(mockWalletUseCase.updateConsent(entity, requestId)).thenThrow(Exception(exception));
      return updateConsentDialogBloc;
    },
    act: (bloc) => bloc.add(ConsentUpdateDialogSubmittedEvent(updateConsent: entity, requestId: requestId)),
    expect: () => [
      MyConsentLoaderState(),
      MyConsentUpdateErrorState(errorMessage: AppUtils.getErrorMessage(Exception().toString())),
    ],
  );
}
