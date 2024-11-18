import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../domain/entities/courses_entity.dart';

/// A widget that displays a job card with relevant information such as title, subtitle, price, and image.
///
/// The [JobsWidget]` provides a visual representation of a job listing, including an image,
/// job title, subtitle, price, and an "apply now" button. It uses `CoursesEntity` to pass
/// the data needed for each job card.
class JobsWidget extends StatelessWidget {
  final CoursesEntity course;

  /// Creates a `JobsWidget` with the required [course] parameter.
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
      // Set the elevation for the card
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimensions.medium),
        ),
      ),
      child: SizedBox(
        width: 200.w, // Adjust the width according to the screen size
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image with rounded corners
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppDimensions.smallXL),
                topLeft: Radius.circular(AppDimensions.smallXL),
              ),
              child: CachedNetworkImage(
                height: 95.w,
                // Image height
                fit: BoxFit.fill,
                // Fill the container
                filterQuality: FilterQuality.high,
                imageUrl: course.image!,
                // Image URL
                // Placeholder image while loading
                placeholder: (context, url) => Image.asset(
                  Assets.images.dummyCourseImage.path,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
                // Error image if loading fails
                errorWidget: (context, url, error) => Image.asset(
                  Assets.images.dummyCourseImage.path,
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
            // Container for the text content
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display title if it exists
                (course.title != null && course.subTitle != null && course.price != null)
                    ? course.title!.titleMedium(
                        size: AppDimensions.smallXL.sp,
                        color: AppColors.grey9898a5,
                      )
                    : AppDimensions.medium.w.horizontalSpace,
                AppDimensions.extraSmall.verticalSpace, // Vertical space
                // Display subtitle with a limit of 2 lines
                course.subTitle!.titleSemiBold(
                  size: AppDimensions.medium.sp,
                  maxLine: 2,
                ),
                5.verticalSpace, // Vertical space
                // Container for price and "apply now" button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Display price if it's not zero
                    course.price! != "0"
                        ? course.price!.titleExtraBold(
                            size: AppDimensions.smallXXL.sp,
                            color: AppColors.activeGreen,
                          )
                        : const Spacer(),
                    // "Apply now" button with arrow icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SeekerDashboardKeys.applyNow.stringToString.titleBold(
                          size: AppDimensions.smallXL.sp,
                          color: AppColors.primaryColor,
                        ),
                        AppDimensions.extraSmall.w.horizontalSpace, // Horizontal space
                        SvgPicture.asset(Assets.images.rightBlueArrow),
                      ],
                    ),
                  ],
                ),
              ],
            ).symmetricPadding(
              horizontal: AppDimensions.smallXL.sp,
              vertical: AppDimensions.small.sp,
            ),
          ],
        ),
      ),
    );
  }
}
