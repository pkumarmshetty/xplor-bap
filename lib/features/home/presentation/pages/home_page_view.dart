import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';
import '../bloc/home_bloc.dart';
import '../widgets/dashboard_header_widget.dart';
import 'package:xplor/features/multi_lang/domain/mappers/home/home_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import '../widgets/overview_tab.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../widgets/dashboard_app_bar_widget.dart';
import '../widgets/seekers_tab.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context, false);
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return Stack(children: [
          (state is HomeUserDataState)
              ? CustomScrollView(
                  slivers: [
                    const DashBoardAppBarWidget(),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardHeaderWidget(userDataEntity: state.userData),
                          AppDimensions.medium.vSpace(),
                          _buildTabItem(_currentIndex),
                          AppDimensions.mediumXL.vSpace(),
                          tabWidget(_currentIndex),
                        ],
                      ).symmetricPadding(horizontal: AppDimensions.medium.sp),
                    ),
                  ],
                )
              : Container(),
          if (state is HomeUserDataLoadingState) const LoadingAnimation()
        ]);
      }),
    );
  }

  Widget _buildTabItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.dashboardTabBackgroundColor.withOpacity(0.3),
          border: Border.all(color: AppColors.checkBoxDisableColor),
          borderRadius: BorderRadius.circular(12) // Set border radius for all corners
          ),
      child: Row(
        children: [
          tabButtonWidget(index: index, label: HomeKeys.overview.stringToString, position: 0),
          tabButtonWidget(index: index, label: HomeKeys.seekers.stringToString, position: 1),
          tabButtonWidget(index: index, label: HomeKeys.earnings.stringToString, position: 2),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp),
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
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all<Color>(index == position ? AppColors.white : Colors.transparent),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: index == position
                  ? const BorderSide(
                      width: 1,
                      color: AppColors.tabsSelectedColor,
                    )
                  : const BorderSide(color: Colors.transparent),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ), // To remove the default radius.
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = position;
          });
        },
        child: label.titleBold(size: 14.sp, color: index == position ? AppColors.black : AppColors.grey9898a5),
      ),
    );
  }

  Widget tabWidget(int index) {
    switch (index) {
      case 0:
        return const OverviewTab();
      case 1:
        return const SeekersTab();
      case 2:
        return const SeekersTab();
      default:
        return Container();
    }
  }
}
