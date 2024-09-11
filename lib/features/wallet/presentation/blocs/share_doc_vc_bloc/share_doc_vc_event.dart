part of 'share_doc_vc_bloc.dart';

/// Validity of the shared document
enum Validity { once, oneDay, threeDays, customDays }

/// Event class for managing document sharing events in the wallet.
abstract class SharedDocVcEvent extends Equatable {
  const SharedDocVcEvent();
}

/// Initial event indicating the start of adding a document process.
class SharedDocVcInitialEvent extends SharedDocVcEvent {
  const SharedDocVcInitialEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when a file is selected for upload.
class ShareDocVcUpdatedEvent extends SharedDocVcEvent {
  const ShareDocVcUpdatedEvent({required this.validity, required this.remarks});

  final Validity validity;
  final String remarks;

  @override
  List<Object?> get props => [validity, remarks];
}

/// Event triggered when the user submits the document for upload.
class ShareVcSubmittedEvent extends SharedDocVcEvent {
  const ShareVcSubmittedEvent({required this.vcIds, required this.request});

  final List<String> vcIds;
  final String request;

  @override
  List<Object?> get props => [vcIds, request];
}

/// Event triggered when the user chooses to select a file.
class ShareDocumentsEvent extends SharedDocVcEvent {
  const ShareDocumentsEvent({this.selectedDocs, this.documentVcData});

  final List<DocumentVcData>? selectedDocs;
  final DocumentVcData? documentVcData;

  @override
  List<Object?> get props => [selectedDocs, documentVcData];
}

/// Event triggered when the pin is verified
class PinVerifiedEvent extends SharedDocVcEvent {
  const PinVerifiedEvent();

  @override
  List<Object?> get props => [];
}
