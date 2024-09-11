import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../domain/usecase/my_order_usecase.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../core/exception_errors.dart';
import '../../../../apply_course/domain/entities/post_request_entity/status_post_entity.dart';
import '../../../domain/entities/my_orders_entity.dart';
import 'my_orders_event.dart';
import 'my_orders_state.dart';

/// My Orders Bloc.
class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersUseCase myOrdersUseCase;
  List<MyOrdersEntity> ongoingOrders = [];
  List<MyOrdersEntity> completedOrders = [];
  MyOrdersEntity? orderItem;
  int pageCompleted = 1;
  final String pageSize = "10";
  int onGoingTotalCount = 0;
  int onCompTotalCount = 0;

  MyOrdersBloc({required this.myOrdersUseCase}) : super(const MyOrdersInitialState()) {
    on<MyOrdersDataEvent>(_onMyOrdersInitial);
    on<MyOrdersStatusEvent>(_onMyOrdersStatusEvent);
    on<StatusSseResponseEvent>(_onStatusSseResponse);
    on<SuccessOnStatusEvent>(_onSuccessOnStatusEvent);

    on<UpdatedListEvent>(_onUpdatedListEvent);
    on<MyOrdersFailureEvent>(_onMyOrdersFailure);
    on<MyOrdersCompletedEvent>(_onMyOrdersCompleted);

    on<SuccessOnStatusProgressEvent>(_onSuccessOnStatusProgressEvent);
  }

  /// Called when the widget is first created.
  Future<void> _onMyOrdersInitial(MyOrdersDataEvent event, Emitter<MyOrdersState> emit) async {
    if (event.isFirstTime) {
      ongoingOrders = [];
      pageCompleted = 1;
      //onGoingTotalCount = 0;

      emit(MyOrdersFetchedState(
        ongoingOrdersEntity: ongoingOrders,
        completedOrdersEntity: completedOrders,
        orderState: OrderState.loading,
      ));
    }

    try {
      MyOrdersListEntity response = await myOrdersUseCase.getOngoingOrdersData(pageCompleted.toString(), pageSize);
      pageCompleted++;
      ongoingOrders.addAll(response.myOrders);

      onGoingTotalCount = response.totalCount;

      emit(MyOrdersFetchedState(
        onGoingCount: onGoingTotalCount,
        onCompletedCount: onCompTotalCount,
        completedOrdersEntity: List.from(completedOrders),
        ongoingOrdersEntity: List.from(ongoingOrders),
        orderState: OrderState.loaded,
      ));
    } catch (e) {
      /*emit(MyOrdersFailureState(
          errorMessage: AppUtils.getErrorMessage(e.toString())));*/

      emit(MyOrdersFetchedState(
          onGoingCount: onCompTotalCount,
          onCompletedCount: onCompTotalCount,
          ongoingOrdersEntity: ongoingOrders,
          completedOrdersEntity: completedOrders,
          orderState: OrderState.failure,
          errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles My Orders Completed Event.
  Future<void> _onMyOrdersCompleted(MyOrdersCompletedEvent event, Emitter<MyOrdersState> emit) async {
    if (event.isFirstTime) {
      pageCompleted = 1;
      completedOrders = [];
      //onCompTotalCount = 0;

      emit(MyOrdersFetchedState(
        ongoingOrdersEntity: ongoingOrders,
        completedOrdersEntity: completedOrders,
        orderState: OrderState.loading,
      ));
    }

    try {
      MyOrdersListEntity completedOrdersResponse =
          await myOrdersUseCase.getCompletedOrdersData(pageCompleted.toString(), pageSize);
      pageCompleted++;
      completedOrders.addAll(completedOrdersResponse.myOrders);

      onCompTotalCount = completedOrdersResponse.totalCount;
      emit(MyOrdersFetchedState(
        onGoingCount: onGoingTotalCount,
        onCompletedCount: onCompTotalCount,
        completedOrdersEntity: List.from(completedOrders),
        ongoingOrdersEntity: List.from(ongoingOrders),
        orderState: OrderState.loaded,
      ));
    } catch (e) {
      /*  emit(MyOrdersFailureState(
          errorMessage: AppUtils.getErrorMessage(e.toString())));*/

      emit(MyOrdersFetchedState(
          onGoingCount: onCompTotalCount,
          onCompletedCount: onCompTotalCount,
          ongoingOrdersEntity: ongoingOrders,
          completedOrdersEntity: completedOrders,
          orderState: OrderState.failure,
          errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles My Orders Status Event.
  FutureOr<void> _onMyOrdersStatusEvent(MyOrdersStatusEvent myOrderStatusEvent, Emitter<MyOrdersState> emit) {
    //emit(const ApplyFormLoaderState());

    orderItem = myOrderStatusEvent.orderItem;
    emit(MyOrdersFetchedState(
      onGoingCount: onGoingTotalCount,
      onCompletedCount: onCompTotalCount,
      ongoingOrdersEntity: ongoingOrders,
      completedOrdersEntity: completedOrders,
      orderState: OrderState.loading,
    ));
    final sseStream =
        myOrdersUseCase.sseConnection(transactionId: orderItem!.transactionId!, timeout: const Duration(minutes: 2));

    try {
      sseStream.listen(
        (event) {
          if (event.success) {
            add(const StatusSseResponseEvent());
          } else {
            if (event.action == "on_status") {
              if (myOrderStatusEvent.isFromOngoing == true) {
                var courseProgress = 0.0;
                if (event.stops?.isNotEmpty == true) {
                  int? completedCount = event.stops?.where((item) => item.authorization?.status == 'COMPLETED').length;
                  if (completedCount != null && completedCount != 0) {
                    courseProgress = (completedCount / event.stops!.length);
                  }
                }

                if (courseProgress == 1.0) {
                  add(const MyOrdersDataEvent(isFirstTime: true));
                  add(const MyOrdersCompletedEvent(isFirstTime: true));
                } else {
                  add(SuccessOnStatusProgressEvent(progress: courseProgress, position: myOrderStatusEvent.position));
                }
                AppUtils.printLogs("Progress... $courseProgress");
              } else {
                if (event.certificateUrl.isNotEmpty) {
                  add(SuccessOnStatusEvent(baseUrl: event.certificateUrl, orderData: orderItem));
                } else {
                  add(MyOrdersFailureEvent(error: ProfileKeys.notComp.stringToString));
                }
              }
            }
          }
        },
        onError: (error) {
          // Handle error
          AppUtils.printLogs('Error occurred: $error');

          var message = AppUtils.getErrorMessage(error.toString());

          if (message.toString().startsWith('ClientException with SocketNetwork')) {
            message = ExceptionErrors.checkInternetConnection.stringToString;
          }

          add(MyOrdersFailureEvent(error: message));
        },
      );
    } catch (e) {
      add(MyOrdersFailureEvent(error: AppUtils.getErrorMessage(e.toString())));
    }
  }

  /// Handles My Orders Failure Event.
  FutureOr<void> _onMyOrdersFailure(MyOrdersFailureEvent event, Emitter<MyOrdersState> emit) {
    emit(MyOrdersFetchedState(
        onGoingCount: onGoingTotalCount,
        onCompletedCount: onCompTotalCount,
        ongoingOrdersEntity: ongoingOrders,
        completedOrdersEntity: completedOrders,
        orderState: OrderState.failure,
        errorMessage: event.error));
    /*   emit(MyOrdersFailureState(
        errorMessage: AppUtils.getErrorMessage(event.error)));*/
  }

  /// Handles Success On Status Event.
  FutureOr<void> _onSuccessOnStatusEvent(SuccessOnStatusEvent event, Emitter<MyOrdersState> emit) {
    emit(OnStatusSuccessState(baseUrl: AppUtils.getErrorMessage(event.baseUrl), orderData: event.orderData!));

    add(const UpdatedListEvent());
  }

  FutureOr<void> _onUpdatedListEvent(UpdatedListEvent event, Emitter<MyOrdersState> emit) {
    emit(MyOrdersFetchedState(
      ongoingOrdersEntity: ongoingOrders,
      completedOrdersEntity: completedOrders,
      orderState: OrderState.translationLoading,
    ));
  }

  /// Handles Status Sse Response Event.
  FutureOr<void> _onStatusSseResponse(StatusSseResponseEvent event, Emitter<MyOrdersState> emit) {
    String entity = StatusPostEntity(
            itemId: orderItem!.itemDetails!.itemId!,
            domain: orderItem!.domain!,
            deviceId: sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
            transactionId: orderItem!.transactionId!,
            orderId: orderItem!.orderId!)
        .toJson();

    try {
      myOrdersUseCase.status(entity);
    } catch (e) {
      AppUtils.printLogs("init data failed");
      /*     emit(MyOrdersFailureState(
          errorMessage: AppUtils.getErrorMessage(e.toString())));*/

      emit(MyOrdersFetchedState(
          ongoingOrdersEntity: ongoingOrders,
          completedOrdersEntity: completedOrders,
          orderState: OrderState.failure,
          errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onSuccessOnStatusProgressEvent(SuccessOnStatusProgressEvent event, Emitter<MyOrdersState> emit) {
    ongoingOrders[event.position].courseProgress = event.progress;
    emit(MyOrdersFetchedState(
      onGoingCount: onGoingTotalCount,
      onCompletedCount: onCompTotalCount,
      completedOrdersEntity: List.from(completedOrders),
      ongoingOrdersEntity: List.from(ongoingOrders),
      orderState: OrderState.loaded,
    ));
  }
}
