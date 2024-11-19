import 'package:equatable/equatable.dart';

/// Base class for all states related to UpdateConsentDialogBloc.
sealed class UpdateConsentDialogState extends Equatable {
  const UpdateConsentDialogState();

  @override
  List<Object> get props => [];
}

/// Initial state for UpdateConsentDialogBloc.
class UpdateConsentDialogInitial extends UpdateConsentDialogState {
  @override
  List<Object> get props => [];
}

/// States for UpdateConsentDialogBloc.
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

/// States for UpdateConsentDialogBloc.
class MyConsentUpdateErrorState extends UpdateConsentDialogState {
  final String errorMessage;

  const MyConsentUpdateErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

/// MyConsentUpdateSuccessState
class MyConsentUpdateSuccessState extends UpdateConsentDialogState {}

/// States for UpdateConsentDialogBloc.
class MyConsentLoaderState extends UpdateConsentDialogState {
  @override
  List<Object> get props => [];
}
