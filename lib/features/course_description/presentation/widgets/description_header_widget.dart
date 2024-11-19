import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/rating_bar.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../domain/entity/services_items.dart';

class DescriptionHeaderWidget extends StatelessWidget {
  const DescriptionHeaderWidget({super.key, required this.course});

  final CourseDetailsDataEntity course;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimensions.mediumXL.verticalSpace,
        course.descriptor.name.titleBold(size: AppDimensions.medium.sp, color: AppColors.textColor),
        if (course.descriptor.shortDesc.isNotEmpty) AppDimensions.extraSmall.verticalSpace,
        if (course.descriptor.shortDesc.isNotEmpty)
          course.descriptor.shortDesc.titleRegular(size: AppDimensions.medium.sp, color: AppColors.textColor),
        AppDimensions.smallXL.verticalSpace,
        if (course.rateable)
          Row(
            children: [
              RatingBarWidget(
                rating: double.parse(course.rating),
                filledColor: AppColors.primaryColor,
                readable: true,
              ),
              AppDimensions.small.w.horizontalSpace,
              course.rating.titleSemiBold(
                size: AppDimensions.smallXL.sp,
                color: AppColors.primaryColor,
              ),
              AppDimensions.small.w.horizontalSpace,
              SeekerHomeKeys.reviews.stringToString.titleRegular(size: AppDimensions.smallXL.sp)
            ],
          ),
        if (course.tagData != null) AppDimensions.medium.verticalSpace,
        if (course.tagData != null)
          Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(Assets.images.level),
                  AppDimensions.small.w.horizontalSpace,
                  SizedBox(
                    width: 100.w,
                    child: course.tagData!.level.value.titleBold(
                      size: AppDimensions.smallXL.sp,
                      maxLine: 1,
                    ),
                  ),
                  AppDimensions.small.w.horizontalSpace,
                  Container(
                    width: 2.0, // Width of the vertical line
                    height: 13.0, // Height of the vertical line
                    color: AppColors.checkBoxDisableColor, // Color of the vertical line
                  ),
                  AppDimensions.small.w.horizontalSpace,
                  SvgPicture.asset(Assets.images.timer),
                  AppDimensions.small.w.horizontalSpace,
                  SizedBox(
                    width: 100.w,
                    child: course.tagData!.duration.value.titleBold(size: AppDimensions.smallXL.sp, maxLine: 1),
                  ),
                ],
              ),
            ],
          ),
        AppDimensions.medium.verticalSpace,
        course.status == "COMPLETED"
            ? SeekerHomeKeys.completed.stringToString.titleExtraBold(size: 18.sp, color: AppColors.green)
            : course.enrolled
                ? SeekerHomeKeys.enrolled.stringToString.titleExtraBold(
                    size: 18.sp,
                    color: AppColors.green,
                  )
                : (course.price.value != "0"
                        ? "${course.price.value} ${course.price.currency}"
                        : SeekerHomeKeys.free.stringToString)
                    .titleExtraBold(
                    size: AppDimensions.large.sp,
                    color: AppColors.green,
                  ),
        AppDimensions.small.verticalSpace,
      ],
    );
  }
}
