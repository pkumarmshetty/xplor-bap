import 'package:equatable/equatable.dart';

/// Event class for the WalletBloc.
sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

/// Wallet Data Event
class GetWalletDataEvent extends WalletEvent {
  const GetWalletDataEvent();
}

/// Add Document Dialog Event
class AddDocumentDialogEvent extends WalletEvent {
  const AddDocumentDialogEvent();
}

/// Documents Uploaded Event
class DocumentsUploadedEvent extends WalletEvent {
  const DocumentsUploadedEvent();
}

/// Documents Upload Failed
class DocumentsUploadFailedEvent extends WalletEvent {
  const DocumentsUploadFailedEvent();
}

/// Wallet Initial Event
class WalletInitialEvent extends WalletEvent {
  const WalletInitialEvent();
}

/// Wallet Tab Selected
class WalletTabSelectedEvent extends WalletEvent {
  final int position;

  const WalletTabSelectedEvent({required this.position});

  @override
  List<Object> get props => [position];
}

/// Wallet Document Check
class WalletDocumentCheckEvent extends WalletEvent {
  final int position;
  final bool isSelected;

  const WalletDocumentCheckEvent({required this.position, required this.isSelected});

  @override
  List<Object> get props => [position, isSelected];
}

/// Wallet Document Delete
class DocumentDeleteEvent extends WalletEvent {
  const DocumentDeleteEvent();

  @override
  List<Object> get props => [];
}
