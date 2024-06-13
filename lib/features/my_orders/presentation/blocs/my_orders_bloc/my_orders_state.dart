import 'package:equatable/equatable.dart';
import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';

enum OrderState { loading, initial, loaded, translationLoading, failure, empty }

abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [];
}

class MyOrdersFetchedState extends MyOrdersState {
  final OrderState orderState;
  final String? errorMessage;
  final int? onGoingCount;
  final int? onCompletedCount;
  final List<MyOrdersEntity> ongoingOrdersEntity;
  final List<MyOrdersEntity> completedOrdersEntity;

  const MyOrdersFetchedState({
    required this.orderState,
    this.errorMessage,
    this.onGoingCount = 0,
    this.onCompletedCount = 0,
    required this.ongoingOrdersEntity,
    required this.completedOrdersEntity,
  });

  MyOrdersFetchedState copyWith({
    String? errorMessage,
    OrderState? ordersState,
    int? onGoingCount = 0,
    int? onCompletedCount = 0,
    List<MyOrdersEntity>? myOrdersEntity,
    List<MyOrdersEntity>? completedOrdersEntity,
    String? message,
  }) {
    return MyOrdersFetchedState(
      errorMessage: errorMessage ?? this.errorMessage,
      onGoingCount: onGoingCount ?? this.onGoingCount,
      onCompletedCount: onCompletedCount ?? this.onCompletedCount,
      orderState: ordersState ?? orderState,
      ongoingOrdersEntity: myOrdersEntity ?? ongoingOrdersEntity,
      completedOrdersEntity:
          completedOrdersEntity ?? this.completedOrdersEntity,
    );
  }

  @override
  List<Object> get props =>
      [orderState, ongoingOrdersEntity, completedOrdersEntity];
}

class MyOrdersInitialState extends MyOrdersState {
  const MyOrdersInitialState();
}

/*class MyOrdersFailureState extends MyOrdersState {
  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];

  const MyOrdersFailureState({
    required this.errorMessage,
  });
}*/

class OnStatusSuccessState extends MyOrdersState {
  final String baseUrl;

  @override
  List<Object> get props => [baseUrl];

  const OnStatusSuccessState({
    required this.baseUrl,
  });
}
