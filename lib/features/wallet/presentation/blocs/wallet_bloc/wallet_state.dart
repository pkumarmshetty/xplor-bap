import 'package:equatable/equatable.dart';

/// State class for the WalletBloc.
///
class WalletState extends Equatable {
  final int tabIndex;

  const WalletState({required this.tabIndex});

  WalletState copyWith({int? tabIndex}) {
    return WalletState(tabIndex: tabIndex ?? this.tabIndex);
  }

  @override
  List<Object?> get props => [tabIndex];
  // Enable toString() for debugging
}

/*/// Initial State class for the WalletBloc.
final class WalletInitialTabEvent extends WalletState {
  final int position;

  const WalletInitialTabEvent({required this.position});
}

final class AddDocumentDialogState extends WalletState {}

final class DocumentsUploadedSuccessState extends WalletState {}

final class DocumentsUploadedFailureState extends WalletState {}

final class DocumentUploadingState extends WalletState {}

class WalletUpdatedState extends WalletState {
  final int selectedTab;
  final bool isCardSelected;
  final List<DocumentData> docs;

  const WalletUpdatedState(
      {required this.selectedTab,
      required this.isCardSelected,
      required this.docs});

  @override
  
  List<Object> get props => [selectedTab, isCardSelected, docs];

  WalletUpdatedState copyWith({
    final int? tab,
    final bool? cardSelected,
    final List<DocumentData>? documentsList,
  }) {
    return WalletUpdatedState(
        selectedTab: tab ?? selectedTab,
        isCardSelected: cardSelected ?? isCardSelected,
        docs: documentsList ?? docs);
  }
}

class DocumentDeleteSuccessState extends WalletState {
  @override
  List<Object> get props => [];
}

class DocumentDeleteErrorState extends WalletState {
  final String errorMessage;

  const DocumentDeleteErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}*/
