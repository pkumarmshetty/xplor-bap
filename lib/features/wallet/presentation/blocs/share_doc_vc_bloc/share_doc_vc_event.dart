part of 'share_doc_vc_bloc.dart';

abstract class SharedDocVcEvent extends Equatable {
  const SharedDocVcEvent();
}

class SharedDocVcInitialEvent extends SharedDocVcEvent {
  const SharedDocVcInitialEvent();
  @override
  List<Object?> get props => [];
}

class ShareDocVcUpdatedEvent extends SharedDocVcEvent {
  const ShareDocVcUpdatedEvent({this.selectedItem, this.remarks});

  final int? selectedItem;
  final String? remarks;

  @override
  List<Object?> get props => [selectedItem, remarks];
}

class ShareVcSubmittedEvent extends SharedDocVcEvent {
  const ShareVcSubmittedEvent({required this.vcIds, required this.request});

  final List<String> vcIds;
  final String request;

  @override
  List<Object?> get props => [vcIds, request];
}

// class RemarksAddedEvent extends SharedDocVcEvent {
//   const RemarksAddedEvent({required this.remarks});
//   final String remarks;
//   @override
//   List<Object?> get props => [remarks];
// }
