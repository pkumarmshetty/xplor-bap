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

/// A widget that displays a preview of a course, including an image, title,
/// provider information, and status or price details.
class CoursesPreviewWidget extends StatelessWidget {
  /// The course data to be displayed in the preview.
  final SearchItemEntity course;

  /// Creates a [CoursesPreviewWidget].
  ///
  /// Requires a [SearchItemEntity] [course] to be passed.
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
            // Course image with rounded corners.
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppDimensions.smallXL),
                  topLeft: Radius.circular(AppDimensions.smallXL)),
              child: CachedNetworkImage(
                  width: 200.w,
                  height: 140.w,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  imageUrl: course.descriptor.images.isNotEmpty
                      ? course.descriptor.images[0]
                      : "",
                  // Placeholder if image is loading.
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row containing the provider's image and name.
                  Row(
                    children: [
                      course.provider.images.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(AppDimensions.smallXL),
                              ),
                              child: CachedNetworkImage(
                                  height: AppDimensions.medium.w,
                                  width: AppDimensions.medium.w,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  imageUrl: course.provider.images[0],
                                  // Placeholder for provider's image.
                                  placeholder: (context, url) =>
                                      SvgPicture.asset(
                                        Assets.images.icAvtarMale,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      ),
                                  // Error widget for provider's image.
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                        Assets.images.icAvtarMale,
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                      )),
                            )
                          : SvgPicture.asset(
                              Assets.images.icAvtarMale,
                              height: AppDimensions.medium.w,
                              width: AppDimensions.medium.w,
                            ),
                      6.w.horizontalSpace,
                      // Provider's name with styling and ellipsis for overflow.
                      Expanded(
                        child: course.provider.name.titleMedium(
                            textOverFlow: TextOverflow.ellipsis,
                            size: AppDimensions.smallXL.sp,
                            maxLines: 1,
                            color: AppColors.grey9898a5),
                      )
                    ],
                  ),
                  AppDimensions.extraSmall.verticalSpace,
                  // Course name styled as a semi-bold title.
                  course.descriptor.name.titleSemiBold(
                    size: AppDimensions.medium.sp,
                    maxLine: 2,
                  ),
                  //5.verticalSpace,
                  const Spacer(),
                  // Display course status or pricing information.
                  course.status == "COMPLETED"
                      ? SeekerHomeKeys.completed.stringToString
                          .titleExtraBold(
                              size: AppDimensions.smallXXL.sp,
                              color: AppColors.green,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)
                          .singleSidePadding(bottom: AppDimensions.extraSmall)
                      : course.enrolled
                          ? SeekerHomeKeys.enrolled.stringToString
                              .titleExtraBold(
                                  size: AppDimensions.smallXXL.sp,
                                  color: AppColors.green,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis)
                              .singleSidePadding(
                                  bottom: AppDimensions.extraSmall)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: (course.price.value != "0"
                                            ? "${course.price.value} ${course.price.currency}"
                                            : SeekerHomeKeys
                                                .free.stringToString)
                                        .titleExtraBold(
                                  size: AppDimensions.smallXXL.sp,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: AppColors.green,
                                )),
                                // Enroll now button with arrow icon.
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SeekerHomeKeys.enrollNow.stringToString
                                        .titleBold(
                                      size: AppDimensions.smallXL.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                    AppDimensions.extraSmall.w.horizontalSpace,
                                    SvgPicture.asset(
                                        Assets.images.rightBlueArrow)
                                  ],
                                )
                              ],
                            ).singleSidePadding(
                              bottom: AppDimensions.extraSmall)
                ],
              ).symmetricPadding(
                  horizontal: AppDimensions.smallXL.sp,
                  vertical: AppDimensions.small.sp),
            )
          ],
        ),
      ),
    );
  }
}
