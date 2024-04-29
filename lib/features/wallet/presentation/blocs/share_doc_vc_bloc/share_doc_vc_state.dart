part of 'share_doc_vc_bloc.dart';

abstract class SharedDocVcState extends Equatable {
  const SharedDocVcState();
}

class ShareDocVcInitial extends SharedDocVcState {
  @override
  List<Object> get props => [];
}

class SharedSuccessState extends SharedDocVcState {
  @override
  List<Object> get props => [];
}

class SharedLoaderState extends SharedDocVcState {
  @override
  List<Object> get props => [];
}

class SharedFailureState extends SharedDocVcState {
  final String? message;

  const SharedFailureState({this.message});

  @override
  List<Object> get props => [message!];
}

class ShareDialogUpdatedState extends SharedDocVcState {
  final int selectedItem;
  final String inputText;

  const ShareDialogUpdatedState({required this.selectedItem, required this.inputText});

  ShareDialogUpdatedState copyWith({
    String? text,
    int? selectedItem,
  }) {
    return ShareDialogUpdatedState(
      inputText: text ?? inputText,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }

  @override
  List<Object> get props => [inputText, selectedItem];
}

// class ShareDialogSubmittedState extends SharedDocVcState {
//   final int selectedItem;
//   final String inputText;
//
//   const ShareDialogSubmittedState({required this.selectedItem, required this.inputText});
//
//   @override
//   List<Object?> get props => [];
// }
