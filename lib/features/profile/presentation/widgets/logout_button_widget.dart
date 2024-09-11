import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../bloc/agent_profile_bloc/agent_profile_bloc.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../bloc/seeker_profile_bloc/seeker_profile_bloc.dart';

/// A widget that displays a logout button with specific styles and functionality.
///
/// The [LogoutButtonWidget] determines the user's role (either seeker or agent)
/// and triggers the appropriate logout event for the user's profile bloc.
class LogoutButtonWidget extends StatelessWidget {
  /// Creates a [LogoutButtonWidget].
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// [onTap] defines the action to be taken when the button is tapped.
      /// It checks the user's role and dispatches the appropriate logout event.
      onTap: () async {
        // Retrieve the current user's role from shared preferences.
        var role = sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedRole);

        // If the role is seeker, trigger the SeekerProfileLogoutEvent.
        if (role == PrefConstKeys.seekerKey) {
          context.read<SeekerProfileBloc>().add(const SeekerProfileLogoutEvent());
        } else {
          // Otherwise, trigger the AgentProfileLogoutEvent.
          context.read<AgentProfileBloc>().add(const AgentProfileLogoutEvent());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.smallXL, vertical: 21),
        decoration: BoxDecoration(
            // Set the background color of the button.
            color: AppColors.white,
            // Define the border radius of the button.
            borderRadius: BorderRadius.all(Radius.circular(AppDimensions.medium.sp)),
            // Define the border color and width.
            border: Border.all(
              color: AppColors.redColor.withOpacity(0.26),
              width: AppDimensions.extraExtraSmall,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Display the logout text with specific font styles.
            ProfileKeys.logout.stringToString.titleBold(size: AppDimensions.medium.sp, color: AppColors.redColor),
            // Display the logout icon.
            SvgPicture.asset(Assets.images.logoutIcon),
          ],
        ),
      ),
    );
  }
}
