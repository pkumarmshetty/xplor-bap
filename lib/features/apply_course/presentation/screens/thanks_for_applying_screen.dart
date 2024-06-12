import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/apply_course/presentation/blocs/apply_course_bloc.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import 'package:xplor/utils/widgets/build_button.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';

class ThanksForApplyingScreen extends StatelessWidget {
  const ThanksForApplyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              SvgPicture.asset(
                Assets.images.icKycSuccess,
                height: 250.w,
              ),
              AppDimensions.xxlLarge.verticalSpace,
              SeekerHomeKeys.thanksForApplying.stringToString
                  .titleExtraBold(color: AppColors.countryCodeColor, size: AppDimensions.mediumXL.sp),
              AppDimensions.mediumXL.verticalSpace,
              ButtonWidget(
                isValid: true,
                fontSize: AppDimensions.medium.w,
                title: SeekerHomeKeys.startCourse.stringToString,
                radius: AppDimensions.medium.w,
                onPressed: () => _navigation(context, isStartCourse: true),
              ).symmetricPadding(horizontal: AppDimensions.mediumXXL.w),
              AppDimensions.smallXL.verticalSpace,
              GestureDetector(
                onTap: () => _navigation(
                  context,
                ),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppDimensions.medium.w),
                      border: Border.all(
                        color: AppColors.white,
                        width: AppDimensions.smallXL.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryLightColor.withOpacity(0.25),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ]),
                  child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppDimensions.smallXL.w),
                          border: Border.all(
                            color: AppColors.primaryColor,
                            width: 1,
                          )),
                      child: Center(
                        child: SeekerHomeKeys.goToDashboard.stringToString
                            .titleBold(color: AppColors.primaryColor, size: AppDimensions.medium.w)
                            .symmetricPadding(horizontal: AppDimensions.mediumXXL.w, vertical: AppDimensions.small.w),
                      )),
                ).symmetricPadding(horizontal: AppDimensions.mediumXXL.w),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  _navigation(BuildContext context, {bool isStartCourse = false}) {
    if (isStartCourse) {
      sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isStartUrlMyCourse, false);
      Navigator.pushNamedAndRemoveUntil(context, Routes.startCoursePage, (routes) => false,
          arguments: context.read<ApplyCourseBloc>().courseMediaUrl);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.seekerHome,
        (routes) => false,
      );
    }
  }
}
