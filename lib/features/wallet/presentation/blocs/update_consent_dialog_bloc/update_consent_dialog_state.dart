import 'package:equatable/equatable.dart';

sealed class UpdateConsentDialogState extends Equatable {
  const UpdateConsentDialogState();

  @override
  List<Object> get props => [];
}

class UpdateConsentDialogInitial extends UpdateConsentDialogState {
  @override
  List<Object> get props => [];
}

class ConsentUpdateDialogUpdatedState extends UpdateConsentDialogState {
  final int selectedItem;
  final String inputText;

  const ConsentUpdateDialogUpdatedState({required this.selectedItem, required this.inputText});

  ConsentUpdateDialogUpdatedState copyWith({
    String? text,
    int? selectedItem,
  }) {
    return ConsentUpdateDialogUpdatedState(
      inputText: text ?? inputText,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }

  @override
  List<Object> get props => [inputText, selectedItem];
}

class ConsentUpdateDialogSubmittedState extends UpdateConsentDialogState {
  final int selectedItem;
  final String inputText;
  const ConsentUpdateDialogSubmittedState({required this.selectedItem, required this.inputText});
  @override
  List<Object> get props => [inputText, selectedItem];
}

class MyConsentUpdateErrorState extends UpdateConsentDialogState {
  final String errorMessage;

  const MyConsentUpdateErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class MyConsentUpdateSuccessState extends UpdateConsentDialogState {}

class MyConsentLoaderState extends UpdateConsentDialogState {
  @override
  List<Object> get props => [];
}
