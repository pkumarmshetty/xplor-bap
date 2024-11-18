import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_state.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWalletUseCase mockWalletUseCase;
  late WalletVcBloc walletVcBloc;

  DocumentVcResponse documentVc = DocumentVcResponse.fromJson(
      json.decode(readJson('features/wallet_test/helpers/json_responses/get_doc_vc_data.json')));

  const String exception = "Exception";

  final List<String> vcIds = ['vsIds', 'vsIds', 'vsIds'];

  setUp(() {
    mockWalletUseCase = MockWalletUseCase();
    walletVcBloc = WalletVcBloc(useCase: mockWalletUseCase);
  });

  tearDown(() {
    walletVcBloc.close();
  });

  test('emits [WalletVcInitial] when WalletVcBloc is created', () {
    expect(walletVcBloc.state, WalletVcInitial());
  });

  blocTest<WalletVcBloc, WalletVcState>(
    'emits [WalletVcLoadingState, WalletVcSuccessState] when GetWalletVcEvent is added',
    build: () {
      when(mockWalletUseCase.getWalletId()).thenAnswer((_) async => 'WalletId');
      when(mockWalletUseCase.getWalletVcData()).thenAnswer((_) async => documentVc.data);
      return walletVcBloc;
    },
    act: (bloc) => bloc.add(const GetWalletVcEvent()),
    expect: () => [
      const WalletVcLoadingState(),
      WalletVcSuccessState(vcData: documentVc.data),
    ],
  );

  blocTest<WalletVcBloc, WalletVcState>(
    'emits [WalletVcLoadingState, WalletVcFailureState] when GetWalletVcEvent fails',
    build: () {
      when(mockWalletUseCase.getWalletId()).thenAnswer((_) async => 'WalletId');
      when(mockWalletUseCase.getWalletVcData()).thenThrow(Exception(exception));
      return walletVcBloc;
    },
    act: (bloc) => bloc.add(const GetWalletVcEvent()),
    expect: () => [
      const WalletVcLoadingState(),
      WalletVcFailureState(message: Exception(exception).toString()),
    ],
  );

  group('YourBloc', () {
    // Test for _onDocumentSelected
    blocTest<WalletVcBloc, WalletVcState>(
      'emits WalletDocumentSelectedState when a document is selected',
      build: () => walletVcBloc, // Replace with your actual Bloc class
      act: (bloc) {
        // Initialize documentsList with dummy data before calling _onDocumentSelected
        bloc.documentsList = [
          DocumentVcData(tags: ['tag'], isSelected: true),
          DocumentVcData(tags: ['tag2'], isSelected: false),
        ];
        // Add the event to select a document
        bloc.add(const WalletDocumentSelectedEvent(position: 0, isSelected: true));
      },
      expect: () => [
        // Use Matchers to specify conditions for the emitted state
        predicate<WalletDocumentSelectedState>((state) {
          // Ensure the state is of type WalletDocumentSelectedState
          // Verify the number of documents and selected documents
          return state.docs.length == 2 && state.selectedDocs.length == 1;
        }),
      ],
    );

    // Test for _onDocumentsUnselectedEvents
    blocTest<WalletVcBloc, WalletVcState>(
      'should update documentsList and emit WalletDocumentUnselectedState',
      build: () => walletVcBloc, // Initialize your BLoC
      seed: () => const WalletDocumentSelectedState(docs: [], selectedDocs: []),
      act: (bloc) => bloc.add(const WalletDocumentsUnselectedEvent()),
      expect: () => [
        const WalletDocumentUnSelectedState(vcData: []),
      ],
    );
  });

  // blocTest<WalletVcBloc, WalletVcState>(
  //   'emits [WalletVcLoadingState, WalletVcLoadingState] when WalletDelVcEvent is added',
  //   build: () {
  //     when(mockWalletUseCase.getWalletId()).thenAnswer((_) async => 'walletId');
  //     when(mockWalletUseCase.deletedDocVcList(vcIds))
  //         .thenAnswer((_) async => 'vcData');
  //     return walletVcBloc;
  //   },
  //   act: (bloc) => bloc.add(WalletDelVcEvent(vcIds: vcIds)),
  //   expect: () => [const WalletVcLoadingState()],
  // );

  blocTest<WalletVcBloc, WalletVcState>(
    'emits [WalletVcLoadingState, WalletVcFailureState] when WalletDelVcEvent fails',
    build: () {
      when(mockWalletUseCase.deletedDocVcList(any)).thenThrow(Exception(exception));
      return walletVcBloc;
    },
    act: (bloc) => bloc.add(WalletDelVcEvent(vcIds: vcIds)),
    expect: () => [
      const WalletVcLoadingState(),
      WalletVcFailureState(message: Exception(exception).toString()),
    ],
  );
}
