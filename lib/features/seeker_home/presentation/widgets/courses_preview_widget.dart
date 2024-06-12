import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../domain/entities/get_response_entity/services_items.dart';

class CoursesPreviewWidget extends StatelessWidget {
  final SearchItemEntity course;

  const CoursesPreviewWidget({
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
                  height: 140.w,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  imageUrl: course.descriptor.images.isNotEmpty ? course.descriptor.images[0] : "",
                  placeholder: (context, url) => SvgPicture.asset(
                        Assets.images.productThumnail,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ).paddingAll(padding: AppDimensions.small),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                        Assets.images.productThumnail,
                        fit: BoxFit.fill,
                        width: double.infinity,
                      ).paddingAll(padding: AppDimensions.small)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    course.provider.images.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(AppDimensions.smallXL),
                            ),
                            child: CachedNetworkImage(
                                height: 16.w,
                                width: 16.w,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                imageUrl: course.provider.images[0],
                                placeholder: (context, url) => SvgPicture.asset(
                                      Assets.images.icAvtarMale,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                    ),
                                errorWidget: (context, url, error) => SvgPicture.asset(
                                      Assets.images.icAvtarMale,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                    )),
                          )
                        : SvgPicture.asset(Assets.images.icAvtarMale),
                    6.hSpace(),
                    Expanded(
                      child: course.provider.name.titleMedium(
                          textOverFlow: TextOverflow.ellipsis,
                          size: AppDimensions.smallXL.sp,
                          maxLines: 1,
                          color: AppColors.grey9898a5),
                    )
                  ],
                ),
                AppDimensions.extraSmall.vSpace(),
                course.descriptor.name.titleSemiBold(size: AppDimensions.medium.sp, maxLine: 2),
                5.vSpace(),
                course.enrolled
                    ? SeekerHomeKeys.enrolled.stringToString.titleExtraBold(
                        size: 14.sp, color: AppColors.green, maxLines: 1, overflow: TextOverflow.ellipsis)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: (course.price.value != "0"
                                      ? "${course.price.value} ${course.price.currency}"
                                      : SeekerHomeKeys.free.stringToString)
                                  .titleExtraBold(
                            size: 14.sp,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.green,
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SeekerHomeKeys.enrollNow.stringToString.titleBold(
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
            ).symmetricPadding(horizontal: 12.sp, vertical: 8.sp),
          ],
        ),
      ),
    );
  }
}
