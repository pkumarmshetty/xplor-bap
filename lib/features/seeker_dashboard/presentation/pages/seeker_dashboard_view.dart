import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../widgets/dashboard_tab_widget.dart';
import '../widgets/profile_tab_widget.dart';
import '../widgets/wallet_tab_widget.dart';

/// [SeekerDashboardView] is a StatefulWidget that provides the main dashboard
/// interface for the seeker. It allows navigation between the Dashboard,
/// Wallet, and Profile tabs.
class SeekerDashboardView extends StatefulWidget {
  const SeekerDashboardView({super.key});

  @override
  State<SeekerDashboardView> createState() => _SeekerDashboardViewState();
}

class _SeekerDashboardViewState extends State<SeekerDashboardView> {
  /// Index of the currently selected tab.
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
                  // Common header at the top of the screen.
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
                      // Builds the tab bar with current selected index.
                      _buildTabItem(_currentIndex),
                      AppDimensions.medium.verticalSpace,
                      // Displays the content of the selected tab.
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

  /// Builds the tab bar for the dashboard with tabs for Dashboard, Wallet, and Profile.
  Widget _buildTabItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dashboardTabBackgroundColor.withOpacity(0.3),
        border: Border.all(color: AppColors.checkBoxDisableColor),
        borderRadius: BorderRadius.circular(AppDimensions.smallXL.sp),
      ),
      child: Row(
        children: [
          // Dashboard tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.dashboard.stringToString, position: 0),
          // Wallet tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.wallet.stringToString, position: 1),
          // Profile tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.profile.stringToString, position: 2),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp),
    );
  }

  /// Builds a tab button for the given `position` with the specified `label`.
  ///
  /// [index] - The current index of the selected tab.
  /// [label] - The text label for the tab.
  /// [position] - The position of the tab.
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
          backgroundColor: WidgetStateProperty.all<Color>(index == position ? AppColors.white : Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: index == position
                  ? const BorderSide(
                      width: 1,
                      color: AppColors.tabsSelectedColor,
                    )
                  : const BorderSide(color: Colors.transparent),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppDimensions.small),
              ),
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

  /// Returns the widget corresponding to the selected tab.
  ///
  /// [index] - The index of the selected tab.
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
