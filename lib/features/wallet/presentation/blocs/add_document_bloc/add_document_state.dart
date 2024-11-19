import 'package:equatable/equatable.dart';

/// State class for managing document-related states in the wallet.
abstract class AddDocumentsState extends Equatable {
  const AddDocumentsState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the document addition process starts.
class AddDocumentsInitialState extends AddDocumentsState {}

/// State indicating that a file has been selected successfully.
class FileSelectedState extends AddDocumentsState {}

/// State indicating an error during file selection.
class FileSelectedErrorState extends AddDocumentsState {
  final String? message;

  const FileSelectedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating that file name entry was successful.
class FileNameSuccessState extends AddDocumentsState {}

/// State indicating an error in the file name entry.
class FileNameErrorState extends AddDocumentsState {
  final String? message;

  const FileNameErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating that file tags entry was successful.
class FileTagsSuccessState extends AddDocumentsState {}

/// State indicating an error in the file tags entry.
class FileTagsErrorState extends AddDocumentsState {
  final String? message;

  const FileTagsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating that the user has chosen to select a file.
class FileChooseState extends AddDocumentsState {}

/// State indicating that the document has been successfully uploaded.
class DocumentUploadedState extends AddDocumentsState {}

/// State indicating that the document upload process is ongoing.
class DocumentLoaderState extends AddDocumentsState {}

/// State indicating that the document upload has failed.
class DocumentUploadFailState extends AddDocumentsState {}

/// State indicating that all required states (file selected, file name entered, tags entered) are valid.
class ValidState extends AddDocumentsState {
  final bool fileSelectedDone;
  final bool fileNameDone;
  final bool fileTagsDone;

  const ValidState({
    required this.fileSelectedDone,
    required this.fileNameDone,
    required this.fileTagsDone,
  });

  @override
  List<Object?> get props => [fileSelectedDone, fileNameDone, fileTagsDone];

  /// Getter to check if all required states are valid.
  bool get allDone => fileSelectedDone && fileNameDone && fileTagsDone;
}
