part of 'share_doc_vc_bloc.dart';

/// Enum for validity of the shared document
enum ShareState { initial, loading, mPinSuccess, success, failure }

/// Base class for all states related to ShareDocVcBloc.
abstract class SharedDocVcState extends Equatable {
  const SharedDocVcState();
}

class ShareDocVcInitial extends SharedDocVcState {
  @override
  List<Object> get props => [];
}

/// State for updating the validity of the shared document
class ShareDocumentsUpdatedState extends SharedDocVcState {
  final Validity validity;
  final String inputText;
  final String? errorMessage;
  final ShareState shareState;
  final List<DocumentVcData>? selectedDocs; // Marked as final and nullable
  final DocumentVcData? documentVcData; // Marked as final and nullable

  const ShareDocumentsUpdatedState({
    required this.validity,
    required this.inputText,
    this.selectedDocs,
    required this.shareState,
    this.documentVcData,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [validity, inputText, selectedDocs, documentVcData, shareState, errorMessage];

  /// Copy method for updating the validity of the shared document
  ShareDocumentsUpdatedState copyWith({
    Validity? validity,
    String? inputText,
    String? errorMessage,
    ShareState? state,
    List<DocumentVcData>? selectedDocs,
    DocumentVcData? documentVcData,
  }) {
    return ShareDocumentsUpdatedState(
      validity: validity ?? this.validity,
      inputText: inputText ?? this.inputText,
      errorMessage: errorMessage ?? this.errorMessage,
      shareState: state ?? shareState,
      selectedDocs: selectedDocs ?? this.selectedDocs,
      documentVcData: documentVcData ?? this.documentVcData,
    );
  }
}
