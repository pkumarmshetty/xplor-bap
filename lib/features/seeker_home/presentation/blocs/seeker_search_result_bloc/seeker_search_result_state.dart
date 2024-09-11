import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../domain/entities/get_response_entity/services_items.dart';

/// Enum for data state
enum DataState {
  success,
  error,
  sseFailure,
  loading,
}

/// Base state
@immutable
sealed class SeekerSearchResultState extends Equatable {
  const SeekerSearchResultState();

  @override
  List<Object> get props => [];
}

/// Initial state
class SearchResultInitialState extends SeekerSearchResultState {}

/// Search result updated state
class SearchResultUpdatedState extends SeekerSearchResultState {
  final DataState state;
  final String? errorMessage;
  final List<SearchItemEntity>? providerData;

  const SearchResultUpdatedState({
    required this.state,
    this.errorMessage,
    this.providerData,
  });

  @override
  List<Object> get props => [state, providerData!];

  // Copy method
  SearchResultUpdatedState copyWith({
    DataState? state,
    String? errorMessage,
    List<SearchItemEntity>? providerData,
  }) {
    return SearchResultUpdatedState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      providerData: providerData ?? this.providerData,
    );
  }
}
