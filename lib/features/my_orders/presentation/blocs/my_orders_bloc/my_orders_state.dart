import 'package:equatable/equatable.dart';
import 'package:xplor/features/my_orders/domain/entities/my_orders_entity.dart';

/// Represents the different states of the My Orders feature.
enum OrderState {
  loading, // Data is being loaded.
  initial, // Initial state before any data is fetched.
  loaded, // Data has been successfully loaded.
  translationLoading, // Translation of data is in progress.
  failure, // An error occurred while fetching or processing data.
  empty // No orders were found.
}

/// Base class for all My Orders states.
abstract class MyOrdersState extends Equatable {
  const MyOrdersState();

  @override
  List<Object> get props => [];
}

/// State representing fetched My Orders data.
class MyOrdersFetchedState extends MyOrdersState {
  final OrderState orderState;
  final String? errorMessage;
  final int? onGoingCount;
  final int? onCompletedCount;
  final List<MyOrdersEntity> ongoingOrdersEntity;
  final List<MyOrdersEntity> completedOrdersEntity;

  /// Constructor for MyOrdersFetchedState.
  const MyOrdersFetchedState({
    required this.orderState,
    this.errorMessage,
    this.onGoingCount = 0,
    this.onCompletedCount = 0,
    required this.ongoingOrdersEntity,
    required this.completedOrdersEntity,
  });

  /// Creates a copy of the current state with optional modifications.
  MyOrdersFetchedState copyWith({
    String? errorMessage,
    OrderState? ordersState,
    int? onGoingCount = 0,
    int? onCompletedCount = 0,
    List<MyOrdersEntity>? myOrdersEntity,
    List<MyOrdersEntity>? completedOrdersEntity,
    String? message, // Unused parameter, consider removing.
  }) {
    return MyOrdersFetchedState(
      errorMessage: errorMessage ?? this.errorMessage,
      onGoingCount: onGoingCount ?? this.onGoingCount,
      onCompletedCount: onCompletedCount ?? this.onCompletedCount,
      orderState: ordersState ?? orderState,
      ongoingOrdersEntity: myOrdersEntity ?? ongoingOrdersEntity,
      completedOrdersEntity: completedOrdersEntity ?? this.completedOrdersEntity,
    );
  }

  @override
  List<Object> get props => [orderState, ongoingOrdersEntity, completedOrdersEntity];
}

/// Initial state of the My Orders feature.
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

/// State indicating successful retrieval of a status with a base URL.
class OnStatusSuccessState extends MyOrdersState {
  final String baseUrl;
  final MyOrdersEntity orderData;

  @override
  List<Object> get props => [baseUrl, orderData];

  /// Constructor for OnStatusSuccessState.
  const OnStatusSuccessState({
    required this.baseUrl,
    required this.orderData,
  });
}
