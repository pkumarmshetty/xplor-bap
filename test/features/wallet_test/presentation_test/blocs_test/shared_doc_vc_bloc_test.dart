import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/presentation/blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWalletUseCase mockWalletUseCase;
  late SharedDocVcBloc shareDialogBloc;
  const String exception = "Exception";
  const String remarks = "Test Remarks";
  final List<String> vcIds = ['vsIds', 'vsIds', 'vsIds'];

  var request = json.encode({
    "certificateType": "wil",
    "remarks": remarks,
    "restrictions": {"expiresIn": 7 * 24, "viewOnce": true}
  });

  setUp(() {
    mockWalletUseCase = MockWalletUseCase();
    shareDialogBloc = SharedDocVcBloc(walletUseCase: mockWalletUseCase);
  });

  tearDown(() {
    shareDialogBloc.close();
  });

  test('emits [ShareDialogInitial] when ShareDialogBloc is created', () {
    expect(shareDialogBloc.state, ShareDocVcInitial());
  });

  blocTest<SharedDocVcBloc, SharedDocVcState>(
    'emits ShareDocVcInitial state',
    build: () => shareDialogBloc, // Replace with your actual Bloc class
    act: (bloc) => bloc.add(const SharedDocVcInitialEvent()),
    expect: () => [ShareDocVcInitial()],
  );

  blocTest<SharedDocVcBloc, SharedDocVcState>(
    'emits [SharedSuccessState] when ShareVcSubmittedEvent is added and submission is successful',
    build: () {
      when(mockWalletUseCase.sharedWalletVcData(any, any)).thenAnswer((_) async => 'Success');
      return shareDialogBloc;
    },
    act: (bloc) => bloc.add(ShareVcSubmittedEvent(vcIds: vcIds, request: request)),
    expect: () => [
      SharedLoaderState(),
      SharedSuccessState(),
    ],
  );

  blocTest<SharedDocVcBloc, SharedDocVcState>(
    'emits [SharedFailureState] when ShareVcSubmittedEvent is added and submission fails',
    build: () {
      when(mockWalletUseCase.sharedWalletVcData(any, any)).thenThrow(Exception(exception));
      return shareDialogBloc;
    },
    act: (bloc) => bloc.add(ShareVcSubmittedEvent(vcIds: vcIds, request: request)),
    expect: () => [
      SharedLoaderState(),
      SharedFailureState(message: Exception(exception).toString()),
    ],
  );

  blocTest<SharedDocVcBloc, SharedDocVcState>(
    'emits [ShareDialogUpdatedState] with updated selectedItem and inputText when ShareDocVcUpdatedEvent is added and current state is ShareDocVcInitial',
    build: () => shareDialogBloc,
    act: (bloc) => bloc.add(const ShareDocVcUpdatedEvent(selectedItem: 2, remarks: remarks)),
    expect: () => [
      const ShareDialogUpdatedState(selectedItem: 2, inputText: remarks),
    ],
  );

  blocTest<SharedDocVcBloc, SharedDocVcState>(
    'emits [ShareDialogUpdatedState] with updated selectedItem and inputText when ShareDocVcUpdatedEvent is added and current state is not ShareDocVcInitial',
    build: () => shareDialogBloc,
    seed: () => const ShareDialogUpdatedState(selectedItem: 1, inputText: remarks),
    act: (bloc) => bloc.add(const ShareDocVcUpdatedEvent(selectedItem: 2, remarks: remarks)),
    expect: () => [
      const ShareDialogUpdatedState(selectedItem: 2, inputText: remarks),
    ],
  );
}
