import 'dart:io';
import 'package:equatable/equatable.dart';

/// Event class for managing document-related events in the wallet.
abstract class AddDocumentsEvent extends Equatable {
  const AddDocumentsEvent();

  @override
  List<Object?> get props => [];
}

/// Initial event indicating the start of adding a document process.
class AddDocumentInitialEvent extends AddDocumentsEvent {
  const AddDocumentInitialEvent();
}

/// Event triggered when a file is selected for upload.
class FileSelectedEvent extends AddDocumentsEvent {
  final File file;
  final String iconUrl;

  const FileSelectedEvent({
    required this.file,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [file, iconUrl];
}

/// Event triggered when the file name is entered.
class FileNameEvent extends AddDocumentsEvent {
  final String fileName;

  const FileNameEvent({
    required this.fileName,
  });

  @override
  List<Object?> get props => [fileName];
}

/// Event triggered when the user chooses to select a file.
class FileChooseEvent extends AddDocumentsEvent {}

/// Event triggered when the user submits the document for upload.
class AddDocumentSubmittedEvent extends AddDocumentsEvent {
  const AddDocumentSubmittedEvent();
}

/// Event triggered when file tags are entered.
class FileTagsEvent extends AddDocumentsEvent {
  final List<String> tags;

  const FileTagsEvent({
    required this.tags,
  });

  @override
  List<Object?> get props => [tags];
}
