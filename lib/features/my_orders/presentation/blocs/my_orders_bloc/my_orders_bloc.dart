import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/features/my_orders/domain/usecase/my_order_usecase.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../core/exception_errors.dart';
import '../../../../apply_course/domain/entities/post_request_entity/status_post_entity.dart';
import '../../../domain/entities/my_orders_entity.dart';
import 'my_orders_event.dart';
import 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersUseCase myOrdersUseCase;
  List<MyOrdersEntity> ongoingOrders = [];
  List<MyOrdersEntity> completedOrders = [];
  MyOrdersEntity? orderItem;
  int pageCompleted = 1;
  final String pageSize = "10";
  int onGoingTotalCount = 0;
  int onCompTotalCount = 0;

  MyOrdersBloc({required this.myOrdersUseCase})
      : super(const MyOrdersInitialState()) {
    on<MyOrdersDataEvent>(_onMyOrdersInitial);
    on<MyOrdersStatusEvent>(_onMyOrdersStatusEvent);
    on<StatusSseResponseEvent>(_onStatusSseResponse);
    on<SuccessOnStatusEvent>(_onSuccessOnStatusEvent);

    on<UpdatedListEvent>(_onUpdatedListEvent);
    on<MyOrdersFailureEvent>(_onMyOrdersFailure);
    on<MyOrdersCompletedEvent>(_onMyOrdersCompleted);
  }

  Future<void> _onMyOrdersInitial(
      MyOrdersDataEvent event, Emitter<MyOrdersState> emit) async {
    if (event.isFirstTime) {
      ongoingOrders = [];
      pageCompleted = 1;
      onGoingTotalCount = 0;

      emit(MyOrdersFetchedState(
        ongoingOrdersEntity: ongoingOrders,
        completedOrdersEntity: completedOrders,
        orderState: OrderState.loading,
      ));
    }

    try {
      MyOrdersListEntity response = await myOrdersUseCase.getOngoingOrdersData(
          pageCompleted.toString(), pageSize);
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

  Future<void> _onMyOrdersCompleted(
      MyOrdersCompletedEvent event, Emitter<MyOrdersState> emit) async {
    if (event.isFirstTime) {
      pageCompleted = 1;
      completedOrders = [];
      onCompTotalCount = 0;

      emit(MyOrdersFetchedState(
        ongoingOrdersEntity: ongoingOrders,
        completedOrdersEntity: completedOrders,
        orderState: OrderState.loading,
      ));
    }

    try {
      MyOrdersListEntity completedOrdersResponse = await myOrdersUseCase
          .getCompletedOrdersData(pageCompleted.toString(), pageSize);
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

  FutureOr<void> _onMyOrdersStatusEvent(
      MyOrdersStatusEvent event, Emitter<MyOrdersState> emit) {
    //emit(const ApplyFormLoaderState());

    orderItem = event.orderItem;
    emit(MyOrdersFetchedState(
      ongoingOrdersEntity: ongoingOrders,
      completedOrdersEntity: completedOrders,
      orderState: OrderState.loading,
    ));
    final sseStream = myOrdersUseCase.sseConnection(
        transactionId: orderItem!.transactionId!,
        timeout: const Duration(minutes: 2));

    try {
      sseStream.listen(
        (event) {
          if (event.success) {
            add(const StatusSseResponseEvent());
          } else {
            if (event.action == "on_status") {
              if (event.certificateUrl.isNotEmpty) {
                add(SuccessOnStatusEvent(baseUrl: event.certificateUrl));
              } else {
                add(MyOrdersFailureEvent(
                    error: ProfileKeys.notComp.stringToString));
              }
            }
          }
        },
        onError: (error) {
          // Handle error
          if (kDebugMode) {
            print('Error occurred: $error');
          }

          var message = AppUtils.getErrorMessage(error.toString());

          if (message
              .toString()
              .startsWith('ClientException with SocketNetwork')) {
            message = ExceptionErrors.checkInternetConnection.stringToString;
          }

          add(MyOrdersFailureEvent(error: message));
        },
      );
    } catch (e) {
      add(MyOrdersFailureEvent(error: AppUtils.getErrorMessage(e.toString())));
    }
  }

  FutureOr<void> _onMyOrdersFailure(
      MyOrdersFailureEvent event, Emitter<MyOrdersState> emit) {
    emit(MyOrdersFetchedState(
        ongoingOrdersEntity: ongoingOrders,
        completedOrdersEntity: completedOrders,
        orderState: OrderState.failure,
        errorMessage: event.error));
    /*   emit(MyOrdersFailureState(
        errorMessage: AppUtils.getErrorMessage(event.error)));*/
  }

  FutureOr<void> _onSuccessOnStatusEvent(
      SuccessOnStatusEvent event, Emitter<MyOrdersState> emit) {
    emit(
        OnStatusSuccessState(baseUrl: AppUtils.getErrorMessage(event.baseUrl)));

    add(const UpdatedListEvent());
  }

  FutureOr<void> _onUpdatedListEvent(
      UpdatedListEvent event, Emitter<MyOrdersState> emit) {
    emit(MyOrdersFetchedState(
      ongoingOrdersEntity: ongoingOrders,
      completedOrdersEntity: completedOrders,
      orderState: OrderState.translationLoading,
    ));
  }

  FutureOr<void> _onStatusSseResponse(
      StatusSseResponseEvent event, Emitter<MyOrdersState> emit) {
    String entity = StatusPostEntity(
            itemId: orderItem!.itemDetails!.itemId!,
            domain: orderItem!.domain!,
            deviceId:
                sl<SharedPreferencesHelper>().getString(PrefConstKeys.deviceId),
            transactionId: orderItem!.transactionId!,
            orderId: orderItem!.orderId!)
        .toJson();

    try {
      myOrdersUseCase.status(entity);
    } catch (e) {
      if (kDebugMode) {
        print("init data failed");
      }
      /*     emit(MyOrdersFailureState(
          errorMessage: AppUtils.getErrorMessage(e.toString())));*/

      emit(MyOrdersFetchedState(
          ongoingOrdersEntity: ongoingOrders,
          completedOrdersEntity: completedOrders,
          orderState: OrderState.failure,
          errorMessage: AppUtils.getErrorMessage(e.toString())));
    }
  }
}
