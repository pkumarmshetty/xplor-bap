import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/profile/domain/entities/profile_card_options_entity.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../on_boarding/domain/entities/user_data_entity.dart';

class ProfileOptionWidget extends StatelessWidget {
  const ProfileOptionWidget({super.key, required this.item, required this.index, this.userData});

  final ProfileCardOptionsEntity item;
  final UserDataEntity? userData;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushNamed(context, Routes.editProfile, arguments: userData);
        }
      },
      child: Container(
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
      ),
    );
  }
}
