import 'package:equatable/equatable.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';

sealed class MyConsentEvent extends Equatable {
  const MyConsentEvent();

  @override
  List<Object?> get props => [];
}

class GetUserConsentEvent extends MyConsentEvent {
  const GetUserConsentEvent();
}

class ConsentRevokeEvent extends MyConsentEvent {
  final SharedVcDataEntity entity;

  const ConsentRevokeEvent({required this.entity});

  @override
  List<Object?> get props => [entity];
}

// class RemarksAddedEvent extends MyConsentEvent {
//   const RemarksAddedEvent({required this.remarks});
//   final String remarks;
//   @override
//   List<Object?> get props => [remarks];
// }
