import 'package:equatable/equatable.dart';

import '../../../domain/entities/my_orders_entity.dart';

sealed class MyOrdersEvent extends Equatable {
  const MyOrdersEvent();

  @override
  List<Object> get props => [];
}

class MyOrdersDataEvent extends MyOrdersEvent {
  final bool isFirstTime;

  const MyOrdersDataEvent({this.isFirstTime = false});
}

class MyOrdersStatusEvent extends MyOrdersEvent {
  final MyOrdersEntity? orderItem;

  const MyOrdersStatusEvent({this.orderItem});
}

class MyOrdersFailureEvent extends MyOrdersEvent {
  final String error;

  const MyOrdersFailureEvent({required this.error});
}

class StatusSseResponseEvent extends MyOrdersEvent {
  const StatusSseResponseEvent();
}

class MyOrdersCompletedEvent extends MyOrdersEvent {
  final bool isFirstTime;

  const MyOrdersCompletedEvent({this.isFirstTime = false});
}

class SuccessOnStatusEvent extends MyOrdersEvent {
  final String baseUrl;

  const SuccessOnStatusEvent({required this.baseUrl});
}

class UpdatedListEvent extends MyOrdersEvent {
  const UpdatedListEvent();
}
