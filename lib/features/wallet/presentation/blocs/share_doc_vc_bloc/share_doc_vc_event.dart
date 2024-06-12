part of 'share_doc_vc_bloc.dart';

enum Validity { once, oneDay, threeDays, customDays }

abstract class SharedDocVcEvent extends Equatable {
  const SharedDocVcEvent();
}

class SharedDocVcInitialEvent extends SharedDocVcEvent {
  const SharedDocVcInitialEvent();
  @override
  List<Object?> get props => [];
}

class ShareDocVcUpdatedEvent extends SharedDocVcEvent {
  const ShareDocVcUpdatedEvent({required this.validity, required this.remarks});

  final Validity validity;
  final String remarks;

  @override
  List<Object?> get props => [validity, remarks];
}

class ShareVcSubmittedEvent extends SharedDocVcEvent {
  const ShareVcSubmittedEvent({required this.vcIds, required this.request});

  final List<String> vcIds;
  final String request;

  @override
  List<Object?> get props => [vcIds, request];
}

class ShareDocumentsEvent extends SharedDocVcEvent {
  const ShareDocumentsEvent({this.selectedDocs, this.documentVcData});

  final List<DocumentVcData>? selectedDocs;
  final DocumentVcData? documentVcData;

  @override
  List<Object?> get props => [selectedDocs, documentVcData];
}

class PinVerifiedEvent extends SharedDocVcEvent {
  const PinVerifiedEvent();
  @override
  List<Object?> get props => [];
}
