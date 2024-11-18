import 'package:equatable/equatable.dart';

import '../../../domain/entities/update_consent_entity.dart';

/// Base class for all events related to UpdateConsentDialogBloc.
sealed class UpdateConsentDialogEvent extends Equatable {
  const UpdateConsentDialogEvent();

  @override
  List<Object?> get props => [];
}

/// Event for updating the consent.
class ConsentUpdateDialogUpdatedEvent extends UpdateConsentDialogEvent {
  const ConsentUpdateDialogUpdatedEvent({this.selectedItem, this.remarks});

  final int? selectedItem;
  final String? remarks;

  @override
  List<Object?> get props => [selectedItem, remarks];
}

/// Event for submitting the updated consent.
class ConsentUpdateDialogSubmittedEvent extends UpdateConsentDialogEvent {
  const ConsentUpdateDialogSubmittedEvent({required this.updateConsent, required this.requestId});

  final String requestId;

  final UpdateConsentEntity updateConsent;

  @override
  List<Object?> get props => [requestId, updateConsent];
}

/// Event for adding remarks
class RemarksAddedEvent extends UpdateConsentDialogEvent {
  const RemarksAddedEvent({required this.remarks});

  final String remarks;

  @override
  List<Object?> get props => [remarks];
}

/// Event for updating the consent.
class ConsentUpdateEvent extends UpdateConsentDialogEvent {
  const ConsentUpdateEvent();

  @override
  List<Object?> get props => [];
}
