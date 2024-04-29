import 'package:equatable/equatable.dart';

/// Event class for the WalletBloc.
sealed class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class GetWalletDataEvent extends WalletEvent {
  const GetWalletDataEvent();
}

class AddDocumentDialogEvent extends WalletEvent {
  const AddDocumentDialogEvent();
}

class DocumentsUploadedEvent extends WalletEvent {
  const DocumentsUploadedEvent();
}

class DocumentsUploadFailedEvent extends WalletEvent {
  const DocumentsUploadFailedEvent();
}

class WalletInitialEvent extends WalletEvent {
  const WalletInitialEvent();
}

class WalletTabSelectedEvent extends WalletEvent {
  final int position;

  const WalletTabSelectedEvent({required this.position});

  @override
  List<Object> get props => [position];
}

class WalletDocumentCheckEvent extends WalletEvent {
  final int position;
  final bool isSelected;

  const WalletDocumentCheckEvent({required this.position, required this.isSelected});

  @override
  List<Object> get props => [position, isSelected];
}

class DocumentDeleteEvent extends WalletEvent {
  const DocumentDeleteEvent();

  @override
  List<Object> get props => [];
}
