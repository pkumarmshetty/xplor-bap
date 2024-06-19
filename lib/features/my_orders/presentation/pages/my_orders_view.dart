import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/features/my_orders/presentation/blocs/my_orders_bloc/my_orders_bloc.dart';
import 'package:xplor/features/my_orders/presentation/blocs/my_orders_bloc/my_orders_state.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../utils/app_dimensions.dart';
import '../../domain/entities/my_orders_entity.dart';
import '../blocs/my_orders_bloc/my_orders_event.dart';
import '../widgets/order_list_empty_widget.dart';
import '../widgets/orders_card_widget.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  int _currentIndex = 0;
  ScrollController scrollControllerOngoing = ScrollController();
  ScrollController scrollControllerCompleted = ScrollController();

  @override
  void initState() {
    super.initState();
    context
        .read<MyOrdersBloc>()
        .add(const MyOrdersDataEvent(isFirstTime: true));
    context
        .read<MyOrdersBloc>()
        .add(const MyOrdersCompletedEvent(isFirstTime: true));
    scrollControllerOngoing.addListener(_loadMoreOngoingData);
    scrollControllerCompleted.addListener(_loadMoreCompletedData);
  }

  @override
  void dispose() {
    scrollControllerOngoing.dispose();
    scrollControllerCompleted.dispose();
    super.dispose();
  }

  void _loadMoreOngoingData() {
    if (scrollControllerOngoing.position.pixels ==
        scrollControllerOngoing.position.maxScrollExtent) {
      context
          .read<MyOrdersBloc>()
          .add(const MyOrdersDataEvent(isFirstTime: false));
    }
  }

  void _loadMoreCompletedData() {
    if (scrollControllerCompleted.position.pixels ==
        scrollControllerCompleted.position.maxScrollExtent) {
      context
          .read<MyOrdersBloc>()
          .add(const MyOrdersCompletedEvent(isFirstTime: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<MyOrdersBloc, MyOrdersState>(
      listener: (BuildContext context, MyOrdersState state) {
        if (state is MyOrdersFetchedState &&
            state.orderState == OrderState.failure) {
          AppUtils.showSnackBar(context, state.errorMessage!);
        }

        if (state is OnStatusSuccessState) {
          Navigator.pushNamed(context, Routes.certificate,
              arguments: state.baseUrl);
        }
      },
      child:
          BlocBuilder<MyOrdersBloc, MyOrdersState>(builder: (context, state) {
        return AppBackgroundDecoration(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonTopHeader(
                    title: ProfileKeys.myOrders.stringToString,
                    onBackButtonPressed: () => Navigator.pop(context),
                    dividerColor: AppColors.hintColor,
                  ),
                  Column(
                    children: [
                      AppDimensions.mediumXL.vSpace(),
                      if (state is MyOrdersFetchedState) _buildTabItem(state),
                    ],
                  ).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
                  AppDimensions.small.vSpace(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     filtersWidget(
                  //         label: ProfileKeys.latest.stringToString,
                  //         icon: Assets.images.arrowDownGrey),
                  //     filtersWidget(
                  //         label: ProfileKeys.filters.stringToString,
                  //         icon: Assets.images.filterGrey),
                  //   ],
                  // ).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
                ],
              ),
            ),
            SliverFillRemaining(
              child: Stack(children: [
                if (state is MyOrdersFetchedState)
                  tabWidget(_currentIndex, state)
                      .symmetricPadding(horizontal: AppDimensions.mediumXL.w),
                if (state is MyOrdersFetchedState &&
                    state.orderState == OrderState.loading)
                  const LoadingAnimation()
              ]),
            )
          ]),
        );
      }),
    ));
  }

  Widget _buildTabItem(MyOrdersFetchedState state) {
    List<MyOrdersEntity> compOrderData = [];
    compOrderData.addAll(state.ongoingOrdersEntity);
    compOrderData.addAll(state.completedOrdersEntity);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          // Set border radius for all corners
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey100,
              offset: Offset(0, 10),
              blurRadius: 30,
            )
          ]),
      child: Row(
        children: [
          tabButtonWidget(
              index: 0,
              label:
                  "${ProfileKeys.ongoing.stringToString} (${state.onGoingCount})",
              position: 0),
          tabButtonWidget(
              index: 1,
              label:
                  "${ProfileKeys.completed.stringToString} (${compOrderData.length.toString()})",
              position: 1),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp),
    );
  }

  Widget tabWidget(int index, MyOrdersFetchedState state) {
    List<MyOrdersEntity> compOrderData = [];
    compOrderData.addAll(state.ongoingOrdersEntity);
    compOrderData.addAll(state.completedOrdersEntity);

    debugPrint("compOrderData  ${compOrderData.length}");

    switch (index) {
      case 0:
        return state.orderState != OrderState.loading &&
                state.ongoingOrdersEntity.isEmpty
            ? const OrderListEmptyWidget()
            : ListView.separated(
                controller: scrollControllerOngoing,
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.mediumXL),
                separatorBuilder: (BuildContext context, int index) {
                  return AppDimensions.smallXL.vSpace();
                },
                itemBuilder: (BuildContext context, int index) {
                  final ordersEntity = state.ongoingOrdersEntity[index];
                  return OrdersCardWidget(
                    myOrdersEntity: ordersEntity,
                    progress: 0.0,
                  );
                },
                itemCount: state.ongoingOrdersEntity.length,
              );
      case 1:
        return state.orderState != OrderState.loading && compOrderData.isEmpty
            ? const OrderListEmptyWidget()
            : ListView.separated(
                controller: scrollControllerCompleted,
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.mediumXL),
                separatorBuilder: (BuildContext context, int index) {
                  return AppDimensions.smallXL.vSpace();
                },
                itemBuilder: (BuildContext context, int index) {
                  return OrdersCardWidget(
                    progress: 1,
                    isCompleted: true,
                    myOrdersEntity: compOrderData[index],
                  );
                },
                itemCount: compOrderData.length,
              );
      default:
        return Container();
    }
  }

  Widget filtersWidget({required String label, required String icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightBluec2deee),
        borderRadius: BorderRadius.circular(56),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          label.titleSemiBold(
              color: AppColors.tabsHomeUnSelectedColor, size: 12.sp),
          AppDimensions.extraSmall.hSpace(),
          SvgPicture.asset(icon),
        ],
      ),
    );
  }

  Widget tabButtonWidget({
    required int index,
    required String label,
    required int position,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          // minimumSize: Size(0, 0),
          elevation: WidgetStateProperty.all<double>(0),
          backgroundColor: WidgetStateProperty.all<Color>(
              _currentIndex == position
                  ? AppColors.primaryColor
                  : Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
          ),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = position;
          });
        },
        child: label.titleBold(
            size: 14.sp,
            color: _currentIndex == position
                ? AppColors.white
                : AppColors.grey9898a5),
      ),
    );
  }
}
