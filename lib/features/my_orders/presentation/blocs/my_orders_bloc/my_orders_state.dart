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
  final List<MyOrdersEntity> ongoingOrdersEntity;
  final List<MyOrdersEntity> completedOrdersEntity;

  const MyOrdersFetchedState({
    required this.orderState,
    this.errorMessage,
    required this.ongoingOrdersEntity,
    required this.completedOrdersEntity,
  });

  MyOrdersFetchedState copyWith({
    String? errorMessage,
    OrderState? ordersState,
    List<MyOrdersEntity>? myOrdersEntity,
    List<MyOrdersEntity>? completedOrdersEntity,
    String? message,
  }) {
    return MyOrdersFetchedState(
      errorMessage: errorMessage ?? this.errorMessage,
      orderState: ordersState ?? orderState,
      ongoingOrdersEntity: myOrdersEntity ?? ongoingOrdersEntity,
      completedOrdersEntity: completedOrdersEntity ?? this.completedOrdersEntity,
    );
  }

  @override
  List<Object> get props => [orderState, ongoingOrdersEntity, completedOrdersEntity];
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
