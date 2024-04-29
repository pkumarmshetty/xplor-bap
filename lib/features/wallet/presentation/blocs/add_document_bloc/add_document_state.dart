import 'package:equatable/equatable.dart';

/// State class for the AddDocumentBloc.
sealed class AddDocumentsState extends Equatable {
  const AddDocumentsState();

  @override
  List<Object> get props => [];
}

/// Initial State class for the AddDocumentBloc.
final class AddDocumentsInitialState extends AddDocumentsState {}

final class FileSelectedState extends AddDocumentsState {}

final class FileSelectedErrorState extends AddDocumentsState {
  final String? message;

  const FileSelectedErrorState(this.message);
}

final class FileNameSuccessState extends AddDocumentsState {}

final class FileNameErrorState extends AddDocumentsState {
  final String? message;

  const FileNameErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

final class FileTagsSuccessState extends AddDocumentsState {}

final class FileTagsErrorState extends AddDocumentsState {
  final String? message;

  const FileTagsErrorState(this.message);

  @override
  List<Object> get props => [message!];
}

final class FileChooseState extends AddDocumentsState {}

final class DocumentUploadedState extends AddDocumentsState {}

final class DocumentLoaderState extends AddDocumentsState {}

final class DocumentUploadFailState extends AddDocumentsState {}

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
  List<Object> get props => [fileSelectedDone, fileNameDone, fileTagsDone];

  bool get allDone => fileSelectedDone && fileNameDone && fileTagsDone;
}
