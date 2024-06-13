import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/space.dart';

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
        AppDimensions.mediumXL.vSpace(),
        course.descriptor.name
            .titleBold(size: 16.sp, color: AppColors.textColor),
        if (course.descriptor.shortDesc.isNotEmpty)
          AppDimensions.extraSmall.vSpace(),
        if (course.descriptor.shortDesc.isNotEmpty)
          course.descriptor.shortDesc
              .titleRegular(size: 16.sp, color: AppColors.textColor),
        AppDimensions.smallXL.vSpace(),
        if (course.rateable)
          Row(
            children: [
              RatingBarWidget(
                rating: double.parse(course.rating),
                filledColor: AppColors.primaryColor,
                readable: true,
              ),
              AppDimensions.small.hSpace(),
              course.rating.titleSemiBold(
                size: 12.sp,
                color: AppColors.primaryColor,
              ),
              AppDimensions.small.hSpace(),
              SeekerHomeKeys.reviews.stringToString.titleRegular(size: 12.sp)
            ],
          ),
        if (course.tagData != null) AppDimensions.medium.vSpace(),
        if (course.tagData != null)
          Row(
            children: [
              SvgPicture.asset(Assets.images.level),
              AppDimensions.small.hSpace(),
              course.tagData!.level.value
                  .titleBold(size: AppDimensions.smallXL.sp),
              AppDimensions.small.hSpace(),
              Container(
                width: 2.0, // Width of the vertical line
                height: 13.0, // Height of the vertical line
                color: AppColors
                    .checkBoxDisableColor, // Color of the vertical line
              ),
              AppDimensions.small.hSpace(),
              SvgPicture.asset(Assets.images.timer),
              AppDimensions.small.hSpace(),
              course.tagData!.duration.value
                  .titleBold(size: AppDimensions.smallXL.sp),
            ],
          ),
        AppDimensions.medium.vSpace(),
        course.enrolled
            ? SeekerHomeKeys.enrolled.stringToString.titleExtraBold(
                size: 18.sp,
                color: AppColors.green,
              )
            : (course.price.value != "0"
                    ? "${course.price.value} ${course.price.currency}"
                    : SeekerHomeKeys.free.stringToString)
                .titleExtraBold(
                size: 24.sp,
                color: AppColors.green,
              ),
        AppDimensions.small.vSpace(),
      ],
    );
  }
}
