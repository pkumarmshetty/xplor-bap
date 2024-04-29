import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xplor/const/local_storage/shared_preferences_helper.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_add_document_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/add_document_bloc/add_document_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/add_document_bloc/add_document_event.dart';
import 'package:xplor/features/wallet/presentation/blocs/add_document_bloc/add_document_state.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late AddDocumentsBloc addDocumentsBloc;
  late MockWalletUseCase mockWalletUseCase;
  late MockSharedPreferencesHelper prefHelper;
  SharedPreferences pref;

  setUp(() async {
    mockWalletUseCase = MockWalletUseCase();
    SharedPreferences.setMockInitialValues({}); //set values here
    pref = await SharedPreferences.getInstance();
    pref.setString(PrefConstKeys.walletId, "wallet_db9adfb2-a307-4cbb-807d-a43846018869");
    prefHelper = MockSharedPreferencesHelper();
    addDocumentsBloc = AddDocumentsBloc(walletUseCases: mockWalletUseCase, preferencesHelper: prefHelper, helper: pref);
  });

  group('_onAddDocumentInitial', () {
    test('Should set flags to false and emit AddDocumentsInitialState', () async {
      // Arrange
      final initialState = AddDocumentsInitialState();

      // Act
      addDocumentsBloc.add(const AddDocumentInitialEvent());

      // Assert
      await expectLater(
        addDocumentsBloc.stream,
        emitsInOrder([initialState]),
      );
      expect(addDocumentsBloc.fileSelectedDone, false);
      expect(addDocumentsBloc.fileNameDone, false);
      expect(addDocumentsBloc.fileTagsDone, false);
    });
  });

  group('AddDocumentsBloc', () {
    const fileName = 'testfile';
    final fileTags = ['tag1', 'tag2'];
    final file = File('test_path');
    const iconUrl = 'test_icon_url';

    test('initial state should be AddDocumentsInitialState', () {
      expect(addDocumentsBloc.state, equals(AddDocumentsInitialState()));
    });

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileSelectedState] when FileSelectedEvent is added',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(FileSelectedEvent(file: file, iconUrl: iconUrl)),
      expect: () => [FileSelectedState()],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'does not emit state when any flag is false',
      build: () => addDocumentsBloc,
      act: (bloc) {
        bloc
          ..fileSelectedDone = false
          ..fileNameDone = true
          ..fileTagsDone = true;
      },
      expect: () => [], // No state should be emitted
    );
    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileNameSuccessState] when FileNameEvent is added with a valid file name',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(const FileNameEvent(fileName: fileName)),
      expect: () => [FileNameSuccessState()],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileNameErrorState] when FileNameEvent is added with an empty file name',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(const FileNameEvent(fileName: '')),
      expect: () => [const FileNameErrorState("Filename cannot be empty")],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileNameErrorState] when FileNameEvent is added with an invalid file name',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(const FileNameEvent(fileName: 'invalid#name')),
      expect: () => [
        const FileNameErrorState(
            "File name error. Please ensure the file name meets requirements (eg. no special characters) ")
      ],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileTagsErrorState] when FileTagsEvent is added with empty tags',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(const FileTagsEvent(tags: [])),
      expect: () => [const FileTagsErrorState("File tags cannot be empty")],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileTagsSuccessState] when FileTagsEvent is added with valid tags',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(FileTagsEvent(tags: fileTags)),
      expect: () => [FileTagsSuccessState()],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [DocumentUploadedState] when AddDocumentSubmittedEvent is added',
      build: () => addDocumentsBloc,
      act: (bloc) {
        bloc.add(const AddDocumentSubmittedEvent());
      },
      verify: (_) {
        verifyNever(mockWalletUseCase.addDocumentWallet(WalletAddDocumentEntity(
          name: fileName,
          tags: fileTags,
          file: file,
          category: fileName,
          iconUrl: iconUrl,
          walletId: PrefConstKeys.walletId,
        )));
      },
      expect: () => [DocumentLoaderState(), DocumentUploadedState()],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [DocumentUploadFailState] when AddDocumentSubmittedEvent fails',
      build: () => addDocumentsBloc,
      act: (bloc) {
        when(mockWalletUseCase.addDocumentWallet(any)).thenThrow(Exception());
        bloc.add(const AddDocumentSubmittedEvent());
      },
      expect: () => [DocumentLoaderState(), DocumentUploadFailState()],
    );

    blocTest<AddDocumentsBloc, AddDocumentsState>(
      'emits [FileChooseState] when FileChooseEvent is added',
      build: () => addDocumentsBloc,
      act: (bloc) => bloc.add(FileChooseEvent()),
      expect: () => [FileChooseState()],
    );
  });
}
