import 'package:equatable/equatable.dart';
import '../../../../../const/app_state.dart';
import '../../../domain/entities/previous_consent_entity.dart';
import '../../../domain/entities/shared_data_entity.dart';

sealed class MyConsentState extends Equatable {
  const MyConsentState();

  @override
  List<Object> get props => [];
}

final class MyConsentInitial extends MyConsentState {}

/// Loading state
class MyConsentLoadingState extends MyConsentState {
  final AppPageStatus status;

  const MyConsentLoadingState({this.status = AppPageStatus.loading});

  @override
  List<Object> get props => [status];
}

/// Loaded state
class MyConsentLoadedState extends MyConsentState {
  final List<SharedVcDataEntity> myConsents;
  final List<PreviousConsentEntity> previousConsents;
  final AppPageStatus status;

  const MyConsentLoadedState({
    required this.myConsents,
    required this.previousConsents,
    this.status = AppPageStatus.success,
  });

  @override
  List<Object> get props => [myConsents, status];
}

/// Error state
class MyConsentRevokeErrorState extends MyConsentState {
  final String errorMessage;
  final AppPageStatus status;

  const MyConsentRevokeErrorState({
    required this.errorMessage,
    this.status = AppPageStatus.error,
  });

  @override
  List<Object> get props => [errorMessage, status];
}

/// Error state
class MyConsentErrorState extends MyConsentState {
  final String errorMessage;

  const MyConsentErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class MyConsentRevokeSuccessState extends MyConsentState {}
