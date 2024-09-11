import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../domain/entities/certificate_view_arguments.dart';
import '../blocs/my_orders_bloc/my_orders_bloc.dart';
import '../blocs/my_orders_bloc/my_orders_state.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../utils/app_dimensions.dart';
import '../../domain/entities/my_orders_entity.dart';
import '../blocs/my_orders_bloc/my_orders_event.dart';
import '../widgets/order_list_empty_widget.dart';
import '../widgets/orders_card_widget.dart';

/// My Orders View.
class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  /// Variables
  int _currentIndex = 0;
  ScrollController scrollControllerOngoing = ScrollController();
  ScrollController scrollControllerCompleted = ScrollController();

  /// Called when the widget is first created.
  @override
  void initState() {
    super.initState();
    context.read<MyOrdersBloc>().add(const MyOrdersDataEvent(isFirstTime: true));
    context.read<MyOrdersBloc>().add(const MyOrdersCompletedEvent(isFirstTime: true));
    scrollControllerOngoing.addListener(_loadMoreOngoingData);
    scrollControllerCompleted.addListener(_loadMoreCompletedData);
  }

  /// Called when the widget is removed from the tree permanently.
  @override
  void dispose() {
    scrollControllerOngoing.dispose();
    scrollControllerCompleted.dispose();
    super.dispose();
  }

  /// Loads more data when the user scrolls to the end of the list.
  void _loadMoreOngoingData() {
    if (scrollControllerOngoing.position.pixels == scrollControllerOngoing.position.maxScrollExtent) {
      context.read<MyOrdersBloc>().add(const MyOrdersDataEvent(isFirstTime: false));
    }
  }

  /// Loads more data when the user scrolls to the end of the list.
  void _loadMoreCompletedData() {
    if (scrollControllerCompleted.position.pixels == scrollControllerCompleted.position.maxScrollExtent) {
      context.read<MyOrdersBloc>().add(const MyOrdersCompletedEvent(isFirstTime: false));
    }
  }

  /// Builds the widget tree.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<MyOrdersBloc, MyOrdersState>(
      listener: (BuildContext context, MyOrdersState state) {
        // On Error
        if (state is MyOrdersFetchedState && state.orderState == OrderState.failure) {
          AppUtils.showSnackBar(context, state.errorMessage!);
        }
        // On Success
        if (state is OnStatusSuccessState) {
          Navigator.pushNamed(context, Routes.certificate,
              arguments: CertificateViewArguments(certificateUrl: state.baseUrl, ordersEntity: state.orderData));
        }
      },
      child: BlocBuilder<MyOrdersBloc, MyOrdersState>(builder: (context, state) {
        return AppBackgroundDecoration(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonTopHeader(
                title: ProfileKeys.myOrders.stringToString,
                onBackButtonPressed: () => Navigator.pop(context),
                dividerColor: AppColors.hintColor,
              ),

              AppDimensions.mediumXL.verticalSpace,
              if (state is MyOrdersFetchedState)
                _buildTabItem(state).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
              Expanded(
                child: Stack(children: [
                  if (state is MyOrdersFetchedState)
                    tabWidget(_currentIndex, state).symmetricPadding(horizontal: AppDimensions.mediumXL.w),
                  if (state is MyOrdersFetchedState && state.orderState == OrderState.loading) const LoadingAnimation()
                ]),
              ),
              AppDimensions.small.verticalSpace,
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
        );
      }),
    ));
  }

  /// Builds the tab item widget.
  Widget _buildTabItem(MyOrdersFetchedState state) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.extraSmall),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.smallXL),
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
              index: 0, label: "${ProfileKeys.ongoing.stringToString} (${state.onGoingCount})", position: 0),
          tabButtonWidget(
              index: 1, label: "${ProfileKeys.completed.stringToString} (${state.onCompletedCount})", position: 1),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp),
    );
  }

  /// Tab Widget
  Widget tabWidget(int index, MyOrdersFetchedState state) {
    List<MyOrdersEntity> compOrderData = [];
    compOrderData.addAll(state.completedOrdersEntity);

    AppUtils.printLogs("compOrderData  ${compOrderData.length}");

    switch (index) {
      case 0:
        return state.orderState != OrderState.loading && state.ongoingOrdersEntity.isEmpty
            ? const OrderListEmptyWidget()
            : ListView.separated(
                controller: scrollControllerOngoing,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.mediumXL),
                separatorBuilder: (BuildContext context, int index) {
                  return AppDimensions.smallXL.verticalSpace;
                },
                itemBuilder: (BuildContext context, int index) {
                  final ordersEntity = state.ongoingOrdersEntity[index];
                  return OrdersCardWidget(
                    myOrdersEntity: ordersEntity,
                    progress: ordersEntity.courseProgress,
                    position: index,
                  );
                },
                itemCount: state.ongoingOrdersEntity.length,
              );
      case 1:
        return state.orderState != OrderState.loading && compOrderData.isEmpty
            ? const OrderListEmptyWidget()
            : ListView.separated(
                controller: scrollControllerCompleted,
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.mediumXL),
                separatorBuilder: (BuildContext context, int index) {
                  return AppDimensions.smallXL.verticalSpace;
                },
                itemBuilder: (BuildContext context, int index) {
                  return OrdersCardWidget(
                    progress: 1,
                    isCompleted: true,
                    myOrdersEntity: compOrderData[index],
                    position: index,
                  );
                },
                itemCount: compOrderData.length,
              );
      default:
        return Container();
    }
  }

  /// Filters Widget
  Widget filtersWidget({required String label, required String icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: AppDimensions.extraSmall),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.lightBluec2deee),
        borderRadius: BorderRadius.circular(56),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          label.titleSemiBold(color: AppColors.tabsHomeUnSelectedColor, size: AppDimensions.smallXL.sp),
          AppDimensions.extraSmall.w.horizontalSpace,
          SvgPicture.asset(icon),
        ],
      ),
    );
  }

  /// Tab Button Widget
  Widget tabButtonWidget({
    required int index,
    required String label,
    required int position,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: WidgetStateProperty.all<double>(0),
          backgroundColor:
              WidgetStateProperty.all<Color>(_currentIndex == position ? AppColors.primaryColor : Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppDimensions.small))),
          ),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = position;
          });
        },
        child: label.titleBold(
            size: AppDimensions.smallXXL.sp, color: _currentIndex == position ? AppColors.white : AppColors.grey9898a5),
      ),
    );
  }
}
