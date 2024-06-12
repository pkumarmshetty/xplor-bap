import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../domain/entities/courses_entity.dart';

class JobsWidget extends StatelessWidget {
  final CoursesEntity course;

  const JobsWidget({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 1,
      shadowColor: AppColors.tabsUnselectedTextColor,
      surfaceTintColor: AppColors.white,
      // Set the elevation as needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.medium),
        ),
      ),
      child: SizedBox(
        width: 200.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.smallXL), topLeft: Radius.circular(AppDimensions.smallXL)),
              child: CachedNetworkImage(
                  height: 95.w,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  imageUrl: course.image!,
                  placeholder: (context, url) => Image.asset(
                        Assets.images.dummyCourseImagePng.path,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ),
                  errorWidget: (context, url, error) => Image.asset(
                        Assets.images.dummyCourseImagePng.path,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (course.title != null && course.subTitle != null && course.price != null)
                    ? course.title!.titleMedium(size: AppDimensions.smallXL.sp, color: AppColors.grey9898a5)
                    : AppDimensions.medium.hSpace(),
                AppDimensions.extraSmall.vSpace(),
                course.subTitle!.titleSemiBold(size: AppDimensions.medium.sp, maxLine: 2),
                5.vSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    course.price! != "0"
                        ? course.price!.titleExtraBold(
                            size: AppDimensions.smallXXL.sp,
                            color: AppColors.activeGreen,
                          )
                        : const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SeekerDashboardKeys.applyNow.stringToString.titleBold(
                          size: AppDimensions.smallXL.sp,
                          color: AppColors.primaryColor,
                        ),
                        AppDimensions.extraSmall.hSpace(),
                        SvgPicture.asset(Assets.images.rightBlueArrow)
                      ],
                    )
                  ],
                )
              ],
            ).symmetricPadding(horizontal: AppDimensions.smallXL.sp, vertical: AppDimensions.small.sp),
          ],
        ),
      ),
    );
  }
}
