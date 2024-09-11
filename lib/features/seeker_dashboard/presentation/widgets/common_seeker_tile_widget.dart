import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/seeker_entity.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

/// A widget that displays a tile for a seeker, including an icon, title, subtitle, and an arrow indicating navigation.
///
/// This widget is commonly used in lists to display information about seekers in a structured and visually appealing manner.
class CommonSeekerTileWidget extends StatelessWidget {
  const CommonSeekerTileWidget({super.key, required this.item});

  /// The seeker entity containing the data to be displayed in the tile.
  final SeekerEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.medium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadowColor, // Shadow color for the tile.
            offset: Offset(0, 1), // Offset for the shadow.
            blurRadius: 1, // Blur radius for the shadow effect.
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        child: Row(
          children: [
            // Displays the icon associated with the seeker.
            SvgPicture.asset(item.icon!),
            AppDimensions.medium.w.horizontalSpace,
            // Expands to fill the remaining space in the row.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Displays the title of the seeker.
                  item.title!.titleBold(
                    size: AppDimensions.medium.sp,
                    color: AppColors.blackMedium,
                  ),
                  AppDimensions.extraSmall.verticalSpace,
                  // Displays the subtitle of the seeker, with ellipsis if the text overflows.
                  item.subTitle!.titleRegular(
                    size: AppDimensions.smallXL.sp,
                    color: AppColors.blackMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Displays an arrow indicating the tile is navigable.
            SvgPicture.asset(Assets.images.rightArrowProfile),
          ],
        ).paddingAll(padding: AppDimensions.smallXL),
      ),
    );
  }
}
