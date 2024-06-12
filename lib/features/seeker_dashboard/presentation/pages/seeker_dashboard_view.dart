import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../widgets/dashboard_tab_widget.dart';
import '../widgets/profile_tab_widget.dart';
import '../widgets/wallet_tab_widget.dart';

class SeekerDashboardView extends StatefulWidget {
  const SeekerDashboardView({super.key});

  @override
  State<SeekerDashboardView> createState() => _SeekerDashboardViewState();
}

class _SeekerDashboardViewState extends State<SeekerDashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CommonTopHeader(
                    dividerColor: AppColors.hintColor,
                    title: "Shital's ${SeekerDashboardKeys.dashboard.stringToString}",
                    onBackButtonPressed: () => Navigator.pop(context),
                    suffixWidget:
                        SvgPicture.asset(Assets.images.search).singleSidePadding(right: AppDimensions.medium.sp),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTabItem(_currentIndex),
                      AppDimensions.medium.vSpace(),
                      tabWidget(_currentIndex),
                    ],
                  ).paddingAll(padding: AppDimensions.medium.sp)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.dashboardTabBackgroundColor.withOpacity(0.3),
          border: Border.all(color: AppColors.checkBoxDisableColor),
          borderRadius: BorderRadius.circular(AppDimensions.smallXL.sp) // Set border radius for all corners
          ),
      child: Row(
        children: [
          tabButtonWidget(index: index, label: SeekerDashboardKeys.dashboard.stringToString, position: 0),
          tabButtonWidget(index: index, label: SeekerDashboardKeys.wallet.stringToString, position: 1),
          tabButtonWidget(index: index, label: SeekerDashboardKeys.profile.stringToString, position: 2),
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
                Radius.circular(AppDimensions.small),
              ), // To remove the default radius.
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = position;
          });
        },
        child: label.titleBold(
            size: AppDimensions.smallXXL.sp, color: index == position ? AppColors.black : AppColors.grey9898a5),
      ),
    );
  }

  Widget tabWidget(int index) {
    switch (index) {
      case 0:
        return const DashBoardTabWidget();
      case 1:
        return const WalletTagWidget();
      case 2:
        return const ProfileTabWidget();
      default:
        return Container();
    }
  }
}
