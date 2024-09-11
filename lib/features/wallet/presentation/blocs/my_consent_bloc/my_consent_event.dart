import 'package:equatable/equatable.dart';
import '../../../domain/entities/shared_data_entity.dart';

/// Base class for all events related to MyConsentBloc.
sealed class MyConsentEvent extends Equatable {
  const MyConsentEvent();

  @override
  List<Object?> get props => [];
}

/// Event for fetching user consents.
class GetUserConsentEvent extends MyConsentEvent {
  const GetUserConsentEvent();
}

/// Event for revoking user consent.
class ConsentRevokeEvent extends MyConsentEvent {
  final SharedVcDataEntity entity;

  const ConsentRevokeEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}
