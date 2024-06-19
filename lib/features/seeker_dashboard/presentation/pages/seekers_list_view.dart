import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../widgets/skill_tab_widget.dart';

class SeekersListView extends StatefulWidget {
  const SeekersListView({super.key});

  @override
  State<SeekersListView> createState() => _SeekersListViewState();
}

class _SeekersListViewState extends State<SeekersListView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                child: Column(children: [
              CommonTopHeader(
                dividerColor: AppColors.hintColor,
                title: SeekerDashboardKeys.seekers.stringToString,
                onBackButtonPressed: () => Navigator.pop(context),
                suffixWidget: SvgPicture.asset(Assets.images.search)
                    .singleSidePadding(right: AppDimensions.medium.sp),
              ),
              Column(
                children: [
                  _buildTabItem(_currentIndex),
                  tabWidget(_currentIndex),
                ],
              ).paddingAll(padding: AppDimensions.medium.sp)
            ])),
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
          borderRadius: BorderRadius.circular(
              AppDimensions.smallXL.sp) // Set border radius for all corners
          ),
      child: Row(
        children: [
          tabButtonWidget(
              index: index,
              label: SeekerDashboardKeys.skill.stringToString,
              position: 0),
          tabButtonWidget(
              index: index,
              label: SeekerDashboardKeys.retail.stringToString,
              position: 1),
          tabButtonWidget(
              index: index,
              label: SeekerDashboardKeys.agriculture.stringToString,
              position: 2),
          tabButtonWidget(
              index: index,
              label: SeekerDashboardKeys.job.stringToString,
              position: 3),
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
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          elevation: WidgetStateProperty.all<double>(0),
          backgroundColor: WidgetStateProperty.all<Color>(
              index == position ? AppColors.white : Colors.transparent),
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
            size: AppDimensions.smallXXL.sp,
            color: index == position ? AppColors.black : AppColors.grey9898a5),
      ),
    );
  }

  Widget tabWidget(int index) {
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
