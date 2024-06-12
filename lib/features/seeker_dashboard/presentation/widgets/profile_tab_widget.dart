import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'package:xplor/features/seeker_dashboard/presentation/widgets/profile_consent_widget.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/widgets/profile_header__widget.dart';
import '../../../../utils/widgets/profile_skill_tile_widget.dart';

class ProfileTabWidget extends StatefulWidget {
  const ProfileTabWidget({super.key});

  @override
  State<ProfileTabWidget> createState() => _ProfileTabWidgetState();
}

class _ProfileTabWidgetState extends State<ProfileTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileHeaderWidget(
          name: "David John",
          role: 'Joined on 22nd April, 2024',
          imageUrl: '',
          editOnProfile: false,
        ),
        AppDimensions.large.vSpace(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ProfileSkillTileWidget(
                title: SeekerDashboardKeys.jobs.stringToString,
                value: '200',
                icon: Assets.images.job,
                backgroundColor: AppColors.lightGreen.withOpacity(0.25),
              ),
            ),
            AppDimensions.smallXL.hSpace(),
            Expanded(
              child: ProfileSkillTileWidget(
                title: SeekerDashboardKeys.courses.stringToString,
                value: '928',
                icon: Assets.images.skilling,
                backgroundColor: AppColors.lightBlue,
              ),
            ),
          ],
        ),
        AppDimensions.smallXXL.vSpace(),
        const Divider(color: AppColors.hintColor),
        AppDimensions.smallXXL.vSpace(),
        SeekerDashboardKeys.recentActivity.stringToString.titleBold(size: AppDimensions.medium.sp),
        10.vSpace(),
        const ProfileConsentWidget(),
        AppDimensions.smallXL.vSpace(),
        const ProfileConsentWidget(),
      ],
    );
  }
}
