import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/constants.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../domain/entities/wallet_add_document_entity.dart';

import '../../../domain/usecase/wallet_usecase.dart';
import 'add_document_event.dart';
import 'add_document_state.dart';

/// Bloc for handling user role selection events.
class AddDocumentsBloc extends Bloc<AddDocumentsEvent, AddDocumentsState> {
  WalletUseCase walletUseCases;
  SharedPreferencesHelper preferencesHelper;
  SharedPreferences? helper;

  AddDocumentsBloc({required this.walletUseCases, required this.preferencesHelper, this.helper})
      : super(AddDocumentsInitialState()) {
    on<AddDocumentInitialEvent>(_onAddDocumentInitial);
    on<FileSelectedEvent>(_onFileSelected);
    on<FileNameEvent>(_onFileName);
    on<FileTagsEvent>(_onFileTags);
    on<FileChooseEvent>(_onFileChoose);
    on<AddDocumentSubmittedEvent>(_onAddDocumentSubmitted);
  }

  // Define a variable to keep track of the state
  bool fileSelectedDone = false;
  bool fileNameDone = false;
  bool fileTagsDone = false;

  String? fileName, iconUrl;
  List<String>? fileTags;
  File? file;

  Future<void> _onAddDocumentInitial(AddDocumentInitialEvent event, Emitter<AddDocumentsState> emit) async {
    fileSelectedDone = false;
    fileNameDone = false;
    fileTagsDone = false;
    emit(AddDocumentsInitialState());
  }

  Future<void> _onFileChoose(FileChooseEvent event, Emitter<AddDocumentsState> emit) async {
    fileSelectedDone = false;
    emit(FileChooseState());
  }

  Future<void> _onFileSelected(FileSelectedEvent event, Emitter<AddDocumentsState> emit) async {
    try {
      file = event.file;
      iconUrl = event.iconUrl;
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
      emit(FileSelectedErrorState(AppUtils.getErrorMessage(e.toString())));
    }
  }

  Future<void> _onFileName(FileNameEvent event, Emitter<AddDocumentsState> emit) async {
    fileName = event.fileName;
    if (fileName == null || fileName!.isEmpty) {
      emit(const FileNameErrorState("Filename cannot be empty"));
      fileNameDone = false;
      _emitAllStatesDone(emit);
      return;
    }
    if (!RegExp(RegexConstants.noSpecialCharacters).hasMatch(fileName!)) {
      fileNameDone = false;
      emit(const FileNameErrorState(
          "File name error. Please ensure the file name meets requirements (eg. no special characters) "));
      fileNameDone = false;
      _emitAllStatesDone(emit);
      return;
    }
    emit(FileNameSuccessState());
    fileNameDone = true;
    _emitAllStatesDone(emit);
  }

  Future<void> _onFileTags(FileTagsEvent event, Emitter<AddDocumentsState> emit) async {
    fileTags = event.tags;

    // Check if file tags are empty
    if (fileTags == null || fileTags!.isEmpty) {
      emit(const FileTagsErrorState("File tags cannot be empty"));
      fileTagsDone = false;
      _emitAllStatesDone(emit);
      return;
    }

    // If all checks pass, emit success state
    emit(FileTagsSuccessState());
    fileTagsDone = true;
    _emitAllStatesDone(emit);
  }

  // Helper method to emit AllStatesDone state
  void _emitAllStatesDone(Emitter<AddDocumentsState> emit) {
    if (fileSelectedDone && fileNameDone && fileTagsDone) {
      emit(ValidState(
        fileSelectedDone: fileSelectedDone,
        fileNameDone: fileNameDone,
        fileTagsDone: fileTagsDone,
      ));
    }
  }

  Future<void> _onAddDocumentSubmitted(AddDocumentSubmittedEvent event, Emitter<AddDocumentsState> emit) async {
    final String? walletId;

    if (helper != null) {
      walletId = helper!.getString(PrefConstKeys.walletId);
    } else {
      walletId = preferencesHelper.getString(PrefConstKeys.walletId);
    }
    WalletAddDocumentEntity entity = WalletAddDocumentEntity(
      name: fileName,
      tags: fileTags,
      file: file,
      category: fileName,
      iconUrl: iconUrl,
      walletId: walletId,
    );
    try {
      emit(DocumentLoaderState());
      await walletUseCases.addDocumentWallet(entity);
      emit(DocumentUploadedState());
    } catch (e) {
      emit(DocumentUploadFailState());
    }
  }
}
