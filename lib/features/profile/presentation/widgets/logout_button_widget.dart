import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/features/profile/presentation/bloc/agent_profile_bloc/agent_profile_bloc.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../bloc/seeker_profile_bloc/seeker_profile_bloc.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var role = sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedRole);

        if (role == PrefConstKeys.seekerKey) {
          context.read<SeekerProfileBloc>().add(const SeekerProfileLogoutEvent());
        } else {
          context.read<AgentProfileBloc>().add(const AgentProfileLogoutEvent());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 21),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(16.sp)),
            border: Border.all(
              color: AppColors.redColor.withOpacity(0.26),
              width: 2,
            )),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ProfileKeys.logout.stringToString.titleBold(size: 16.sp, color: AppColors.redColor),
          SvgPicture.asset(Assets.images.logoutIcon),
        ]),
      ),
    );
  }
}
