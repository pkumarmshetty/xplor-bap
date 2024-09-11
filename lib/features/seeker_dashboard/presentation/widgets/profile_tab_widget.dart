import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/widgets/profile_header__widget.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'profile_consent_widget.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/widgets/profile_skill_tile_widget.dart';

/// Widget representing the profile tab in the seeker dashboard.
///
/// This widget displays various aspects of the seeker's profile, including
/// profile header, skills (jobs and courses), recent activities, and consent sections.
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
        // Profile header section
        const ProfileHeaderWidget(
          name: "David John",
          role: 'Joined on 22nd April, 2024',
          imageUrl: '', // Placeholder for profile image URL
          editOnProfile: false, // Whether editing is enabled on profile
        ),
        AppDimensions.large.verticalSpace, // Vertical space
        // Row containing skills (jobs and courses)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ProfileSkillTileWidget(
                title: SeekerDashboardKeys.jobs.stringToString, // Jobs title
                value: '200', // Number of jobs
                icon: Assets.images.job, // Icon for jobs
                backgroundColor: AppColors.lightGreen.withOpacity(0.25), // Background color
              ),
            ),
            AppDimensions.smallXL.w.horizontalSpace, // Horizontal space
            Expanded(
              child: ProfileSkillTileWidget(
                title: SeekerDashboardKeys.courses.stringToString,
                // Courses title
                value: '928',
                // Number of courses
                icon: Assets.images.skilling,
                // Icon for courses
                backgroundColor: AppColors.lightBlue, // Background color
              ),
            ),
          ],
        ),
        AppDimensions.smallXXL.verticalSpace, // Vertical space
        const Divider(color: AppColors.hintColor), // Divider
        AppDimensions.smallXXL.verticalSpace, // Vertical space
        // Title for recent activity section
        SeekerDashboardKeys.recentActivity.stringToString.titleBold(size: AppDimensions.medium.sp),
        10.verticalSpace, // Vertical space
        const ProfileConsentWidget(), // Consent widget
        AppDimensions.smallXL.verticalSpace, // Vertical space
        const ProfileConsentWidget(), // Consent widget
      ],
    );
  }
}
