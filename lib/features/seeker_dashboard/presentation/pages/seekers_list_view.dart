import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../widgets/skill_tab_widget.dart';

/// A StatefulWidget representing a list view of seekers. The view contains tabs for different categories of seekers.
class SeekersListView extends StatefulWidget {
  const SeekersListView({super.key});

  @override
  State<SeekersListView> createState() => _SeekersListViewState();
}

class _SeekersListViewState extends State<SeekersListView> {
  /// The index of the currently selected tab.
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: CustomScrollView(
          slivers: [
            // Using SliverFillRemaining to fill the remaining space.
            SliverFillRemaining(
              child: Column(
                children: [
                  // Top header with back button and search icon.
                  CommonTopHeader(
                    dividerColor: AppColors.hintColor,
                    title: SeekerDashboardKeys.seekers.stringToString,
                    onBackButtonPressed: () => Navigator.pop(context),
                    suffixWidget:
                        SvgPicture.asset(Assets.images.search).singleSidePadding(right: AppDimensions.medium.sp),
                  ),
                  Column(
                    children: [
                      // Tab bar with different categories.
                      _buildTabItem(_currentIndex),
                      // Display content based on selected tab.
                      tabWidget(_currentIndex),
                    ],
                  ).paddingAll(padding: AppDimensions.medium.sp)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the tab bar for the seekers list view with tabs for Skill, Retail, Agriculture, and Job.
  ///
  /// [index] - The current index of the selected tab.
  Widget _buildTabItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.dashboardTabBackgroundColor.withOpacity(0.3),
          border: Border.all(color: AppColors.checkBoxDisableColor),
          borderRadius: BorderRadius.circular(AppDimensions.smallXL.sp) // Set border radius for all corners
          ),
      child: Row(
        children: [
          // Skill tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.skill.stringToString, position: 0),
          // Retail tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.retail.stringToString, position: 1),
          // Agriculture tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.agriculture.stringToString, position: 2),
          // Job tab button.
          tabButtonWidget(index: index, label: SeekerDashboardKeys.job.stringToString, position: 3),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp),
    );
  }

  /// Creates a tab button for the given `position` with the specified `label`.
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
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimensions.small.sp),
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
    // Based on the index, returns the appropriate widget for the tab.
    // Currently, all tabs return the same `SkillTabWidget`.
    switch (index) {
      case 0:
        return const SkillTabWidget();
      case 1:
        return const SkillTabWidget();
      case 2:
        return const SkillTabWidget();
      case 3:
        return const SkillTabWidget();
      default:
        return Container();
    }
  }
}
