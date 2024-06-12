import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/seeker_dashboard/domain/entities/seeker_entity.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class CommonSeekerTileWidget extends StatelessWidget {
  const CommonSeekerTileWidget({super.key, required this.item});

  final SeekerEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.medium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadowColor, // Shadow color
            offset: Offset(0, 1), // Offset
            blurRadius: 1, // Blur radius
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        child: Row(
          children: [
            SvgPicture.asset(item.icon!),
            AppDimensions.medium.hSpace(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.title!.titleBold(
                    size: AppDimensions.medium.sp,
                    color: AppColors.blackMedium,
                  ),
                  AppDimensions.extraSmall.vSpace(),
                  item.subTitle!.titleRegular(
                    size: AppDimensions.smallXL.sp,
                    color: AppColors.blackMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(Assets.images.rightArrowProfile),
          ],
        ).paddingAll(padding: AppDimensions.smallXL),
      ),
    );
  }
}
