part of 'apply_course_bloc.dart';

abstract class ApplyCourseEvent extends Equatable {
  const ApplyCourseEvent();
}

class UpdateInitStateEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SeekerFailureEvent extends ApplyCourseEvent {
  final String error;

  const SeekerFailureEvent({required this.error});

  @override
  List<Object?> get props => [];
}

class CourseDocumentSelectedEvent extends ApplyCourseEvent {
  final DocumentVcData selectedDoc;

  @override
  List<Object?> get props => [selectedDoc];

  const CourseDocumentSelectedEvent({
    required this.selectedDoc,
  });
}

class DocumentLinkCopiedEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const DocumentLinkCopiedEvent();
}

class CourseDocumentRemovedEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const CourseDocumentRemovedEvent();
}

/*class ConnectSSEEvent extends ApplyCourseEvent {
  final String transactionId;
  final String domain;

  @override
  List<Object?> get props => [transactionId, domain];

  const ConnectSSEEvent({
    required this.transactionId,
    required this.domain,
  });
}*/

class FormSubmitSuccessfully extends ApplyCourseEvent {
  const FormSubmitSuccessfully();

  @override
  List<Object?> get props => [];
}

class SelectSseResponseEvent extends ApplyCourseEvent {
  final String transactionId;

  @override
  List<Object?> get props => [transactionId];

  const SelectSseResponseEvent({required this.transactionId});
}

class CourseSelectEvent extends ApplyCourseEvent {
  final CourseDetailsDataEntity data;
  final String transactionId;

  @override
  List<Object?> get props => [transactionId];

  const CourseSelectEvent({
    required this.data,
    required this.transactionId,
  });
}

class CourseGetUrlEvent extends ApplyCourseEvent {
  final String url;

  const CourseGetUrlEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class PaymentEvent extends ApplyCourseEvent {
  final String url;

  const PaymentEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class OnSelectResponseEvent extends ApplyCourseEvent {
  final SseServicesEntity order;

  const OnSelectResponseEvent({required this.order});

  @override
  List<Object?> get props => [order];
}

class CourseInitEvent extends ApplyCourseEvent {
  final String transactionId;
  final String domain;

  @override
  List<Object?> get props => [transactionId, domain];

  const CourseInitEvent({
    required this.transactionId,
    required this.domain,
  });
}

class InitSseResponseEvent extends ApplyCourseEvent {
  final String transactionId;
  final String domain;

  @override
  List<Object?> get props => [transactionId, domain];

  const InitSseResponseEvent({
    required this.transactionId,
    required this.domain,
  });
}

class ConfirmSseResponseEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const ConfirmSseResponseEvent();
}

class CourseConfirmEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const CourseConfirmEvent();
}

/*class StatusSseResponseEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const StatusSseResponseEvent();
}

class CourseStatusEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const CourseStatusEvent();
}*/

class SuccessNavigatedEvent extends ApplyCourseEvent {
  @override
  List<Object?> get props => [];

  const SuccessNavigatedEvent();
}
