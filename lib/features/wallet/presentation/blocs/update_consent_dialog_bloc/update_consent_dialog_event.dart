import 'package:equatable/equatable.dart';

import '../../../domain/entities/update_consent_entity.dart';

sealed class UpdateConsentDialogEvent extends Equatable {
  const UpdateConsentDialogEvent();

  @override
  List<Object?> get props => [];
}

class ConsentUpdateDialogUpdatedEvent extends UpdateConsentDialogEvent {
  const ConsentUpdateDialogUpdatedEvent({this.selectedItem, this.remarks});

  final int? selectedItem;
  final String? remarks;

  @override
  List<Object?> get props => [selectedItem, remarks];
}

class ConsentUpdateDialogSubmittedEvent extends UpdateConsentDialogEvent {
  const ConsentUpdateDialogSubmittedEvent({required this.updateConsent, required this.requestId});

  final String requestId;

  final UpdateConsentEntity updateConsent;

  @override
  List<Object?> get props => [requestId, updateConsent];
}

class RemarksAddedEvent extends UpdateConsentDialogEvent {
  const RemarksAddedEvent({required this.remarks});

  final String remarks;

  @override
  List<Object?> get props => [remarks];
}

class ConsentUpdateEvent extends UpdateConsentDialogEvent {
  const ConsentUpdateEvent();

  @override
  List<Object?> get props => [];
}
