import 'package:equatable/equatable.dart';
import '../../../domain/entities/my_orders_entity.dart';

/// Sealed class representing events related to MyOrdersBloc.
sealed class MyOrdersEvent extends Equatable {
  const MyOrdersEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch my orders data.
class MyOrdersDataEvent extends MyOrdersEvent {
  final bool isFirstTime;

  const MyOrdersDataEvent({this.isFirstTime = false});
}

/// Event to update status of a specific order.
class MyOrdersStatusEvent extends MyOrdersEvent {
  final MyOrdersEntity? orderItem;
  final bool? isFromOngoing;
  final int position;

  const MyOrdersStatusEvent({this.orderItem, this.isFromOngoing = false, required this.position});
}

/// Event to handle failure in MyOrdersBloc.
class MyOrdersFailureEvent extends MyOrdersEvent {
  final String error;

  const MyOrdersFailureEvent({required this.error});
}

/// Event triggered upon receiving SSE response related to status.
class StatusSseResponseEvent extends MyOrdersEvent {
  const StatusSseResponseEvent();
}

/// Event to fetch completed orders data.
class MyOrdersCompletedEvent extends MyOrdersEvent {
  final bool isFirstTime;

  const MyOrdersCompletedEvent({this.isFirstTime = false});
}

/// Event triggered upon successful status update.
class SuccessOnStatusEvent extends MyOrdersEvent {
  final String baseUrl;
  final MyOrdersEntity? orderData;

  const SuccessOnStatusEvent({required this.baseUrl, this.orderData});
}

/// Event to signal an updated list of orders.
class SuccessOnStatusProgressEvent extends MyOrdersEvent {
  final double progress;
  final int position;

  const SuccessOnStatusProgressEvent({required this.progress, required this.position});
}

class UpdatedListEvent extends MyOrdersEvent {
  const UpdatedListEvent();
}
