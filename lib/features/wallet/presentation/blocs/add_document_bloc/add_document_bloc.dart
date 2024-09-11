import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/constants.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/entities/wallet_add_document_entity.dart';
import '../../../domain/usecase/wallet_usecase.dart';
import 'add_document_event.dart';
import 'add_document_state.dart';

/// BLoC for managing the state related to adding documents to the wallet.
class AddDocumentsBloc extends Bloc<AddDocumentsEvent, AddDocumentsState> {
  WalletUseCase walletUseCases;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  // State variables to track completion of each step
  bool fileSelectedDone = false;
  bool fileNameDone = false;
  bool fileTagsDone = false;

  // Variables to store document details
  String? fileName, iconUrl;
  List<String>? fileTags;
  File? file;

  /// Constructor initializing with required dependencies and setting up event listeners.
  AddDocumentsBloc({
    required this.walletUseCases,
    required this.preferencesHelper,
    this.helper,
  }) : super(AddDocumentsInitialState()) {
    on<AddDocumentInitialEvent>(_onAddDocumentInitial);
    on<FileSelectedEvent>(_onFileSelected);
    on<FileNameEvent>(_onFileName);
    on<FileTagsEvent>(_onFileTags);
    on<FileChooseEvent>(_onFileChoose);
    on<AddDocumentSubmittedEvent>(_onAddDocumentSubmitted);
  }

  /// Resets the state and emits [AddDocumentsInitialState].
  Future<void> _onAddDocumentInitial(AddDocumentInitialEvent event, Emitter<AddDocumentsState> emit) async {
    fileSelectedDone = false;
    fileNameDone = false;
    fileTagsDone = false;
    emit(AddDocumentsInitialState());
  }

  /// Emits [FileChooseState] to indicate file selection event.
  Future<void> _onFileChoose(FileChooseEvent event, Emitter<AddDocumentsState> emit) async {
    fileSelectedDone = false;
    emit(FileChooseState());
  }

  /// Handles file selection event, validates file size, and updates state accordingly.
  Future<void> _onFileSelected(FileSelectedEvent event, Emitter<AddDocumentsState> emit) async {
    try {
      file = event.file;
      iconUrl = event.iconUrl;

      // Check if file size exceeds the limit (10 MB)
      if ((file!.lengthSync() > 10 * 1024 * 1024)) {
        emit(FileSelectedState());
        fileSelectedDone = false;
        _emitAllStatesDone(emit);
      } else {
        emit(FileSelectedState());
        fileSelectedDone = true;
        _emitAllStatesDone(emit);
      }
    } catch (e) {
      // Handle any exceptions during file selection
      emit(FileSelectedErrorState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles file name validation event.
  Future<void> _onFileName(FileNameEvent event, Emitter<AddDocumentsState> emit) async {
    fileName = event.fileName;

    // Check if file name is empty
    if (fileName == null || fileName!.isEmpty) {
      emit(FileNameErrorState(WalletKeys.fileNameCannotBeEmpty.stringToString));
      fileNameDone = false;
      _emitAllStatesDone(emit);
      return;
    }

    // Check if file name contains special characters
    if (!RegExp(RegexConstants.noSpecialCharacters).hasMatch(fileName!)) {
      fileNameDone = false;
      emit(FileNameErrorState(WalletKeys.fileNameErrorMessage.stringToString));
      fileNameDone = false;
      _emitAllStatesDone(emit);
      return;
    }

    // File name is valid, emit success state
    emit(FileNameSuccessState());
    fileNameDone = true;
    _emitAllStatesDone(emit);
  }

  /// Handles file tags validation event.
  Future<void> _onFileTags(FileTagsEvent event, Emitter<AddDocumentsState> emit) async {
    fileTags = event.tags;

    // Check if file tags are empty
    if (fileTags == null || fileTags!.isEmpty) {
      emit(FileTagsErrorState(WalletKeys.fileTagCannotBeEmpty.stringToString));
      fileTagsDone = false;
      _emitAllStatesDone(emit);
      return;
    }

    // File tags are valid, emit success state
    emit(FileTagsSuccessState());
    fileTagsDone = true;
    _emitAllStatesDone(emit);
  }

  /// Helper method to emit [ValidState] when all states are done.
  void _emitAllStatesDone(Emitter<AddDocumentsState> emit) {
    if (fileSelectedDone && fileNameDone && fileTagsDone) {
      emit(ValidState(
        fileSelectedDone: fileSelectedDone,
        fileNameDone: fileNameDone,
        fileTagsDone: fileTagsDone,
      ));
    }
  }

  /// Handles document submission event.
  Future<void> _onAddDocumentSubmitted(AddDocumentSubmittedEvent event, Emitter<AddDocumentsState> emit) async {
    final String? walletId;

    // Retrieve wallet ID from SharedPreferences or local helper
    if (helper != null) {
      walletId = helper!.getString(PrefConstKeys.walletId);
    } else {
      walletId = preferencesHelper.getString(PrefConstKeys.walletId);
    }

    // Create entity with document details
    WalletAddDocumentEntity entity = WalletAddDocumentEntity(
      name: fileName,
      tags: fileTags,
      file: file,
      category: fileName,
      // Replace with actual category if applicable
      iconUrl: iconUrl,
      walletId: walletId,
    );

    try {
      emit(DocumentLoaderState()); // Emit loading state
      await walletUseCases.addDocumentWallet(entity); // Call use case to add document
      emit(DocumentUploadedState()); // Emit success state after document upload
    } catch (e) {
      emit(DocumentUploadFailState()); // Emit failure state on exception
    }
  }
}
