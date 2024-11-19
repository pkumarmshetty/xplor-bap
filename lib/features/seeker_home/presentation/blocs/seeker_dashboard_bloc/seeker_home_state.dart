import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../domain/entities/get_response_entity/services_items.dart';

/// Enum for data state
enum DataState {
  success,
  error,
  loading,
  sseFailure,
}

/// Base state
@immutable
sealed class SeekerHomeState extends Equatable {
  const SeekerHomeState();

  @override
  List<Object> get props => [];
}

/// Initial state
class SeekerHomeInitialState extends SeekerHomeState {}

/// Seeker home updated state
class SeekerHomeUpdatedState extends SeekerHomeState {
  final DataState state;
  final String? errorMessage;
  final List<SearchItemEntity>? providerData;

  const SeekerHomeUpdatedState({
    required this.state,
    this.errorMessage,
    this.providerData,
  });

  @override
  List<Object> get props => [state, providerData!];

  // Copy method
  SeekerHomeUpdatedState copyWith({
    DataState? state,
    String? errorMessage,
    List<SearchItemEntity>? providerData,
  }) {
    return SeekerHomeUpdatedState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      providerData: providerData ?? this.providerData,
    );
  }
}
