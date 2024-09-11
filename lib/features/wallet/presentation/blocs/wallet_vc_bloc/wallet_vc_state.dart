import 'package:equatable/equatable.dart';

import '../../../domain/entities/wallet_vc_list_entity.dart';

sealed class WalletVcState extends Equatable {
  const WalletVcState();

  @override
  List<Object> get props => [];
}

final class WalletVcInitial extends WalletVcState {}

/// Loading state
class WalletVcLoadingState extends WalletVcState {
  const WalletVcLoadingState();
}

/// Loaded state
class WalletVcSuccessState extends WalletVcState {
  final List<DocumentVcData> vcData;

  const WalletVcSuccessState({
    required this.vcData,
  });

  @override
  List<Object> get props => [
        vcData,
      ];
}

class WalletVcFailureState extends WalletVcState {
  final String? message;

  const WalletVcFailureState({
    required this.message,
  });

  @override
  List<Object> get props => [message!];
}

class WalletDocumentSelectedState extends WalletVcState {
  final List<DocumentVcData> docs;
  final List<DocumentVcData> selectedDocs;

  const WalletDocumentSelectedState({
    required this.docs,
    required this.selectedDocs,
  });

  @override
  List<Object> get props => [docs, selectedDocs];
}

class WalletDocumentUnSelectedState extends WalletVcState {
  final List<DocumentVcData> vcData;

  const WalletDocumentUnSelectedState({
    required this.vcData,
  });

  @override
  List<Object> get props => [vcData];
}

class WalletDocumentsSearchedState extends WalletVcState {
  final List<DocumentVcData> searchedDocuments;
  final List<DocumentVcData> selectedDocuments;

  const WalletDocumentsSearchedState({
    required this.searchedDocuments,
    required this.selectedDocuments,
  });

  @override
  List<Object> get props => [searchedDocuments, selectedDocuments];
}

class DelWalletSuccessState extends WalletVcState {
  const DelWalletSuccessState();
}
