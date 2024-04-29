import 'dart:io';
import 'package:equatable/equatable.dart';

/// Event class for the AddDocumentBloc.
sealed class AddDocumentsEvent extends Equatable {
  const AddDocumentsEvent();

  @override
  List<Object> get props => [];
}

class AddDocumentInitialEvent extends AddDocumentsEvent {
  const AddDocumentInitialEvent();
}

class FileSelectedEvent extends AddDocumentsEvent {
  final File file;
  final String iconUrl;

  const FileSelectedEvent({
    required this.file,
    required this.iconUrl,
  });
}

class FileNameEvent extends AddDocumentsEvent {
  final String fileName;

  const FileNameEvent({
    required this.fileName,
  });
}

class FileChooseEvent extends AddDocumentsEvent {}

class AddDocumentSubmittedEvent extends AddDocumentsEvent {
  const AddDocumentSubmittedEvent();
}

class FileTagsEvent extends AddDocumentsEvent {
  final List<String> tags;

  const FileTagsEvent({
    required this.tags,
  });
}
