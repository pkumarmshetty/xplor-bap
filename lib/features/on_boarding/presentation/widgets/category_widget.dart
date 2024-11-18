import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
    required this.isSelected,
    required this.category,
    required this.onSelect,
  });

  final bool isSelected;
  final String category;
  final Function(bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        // Handle onTap action here
        onSelect(!isSelected);
      },
      child: Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: AppDimensions.extraExtraSmall,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.medium.w),
            side: BorderSide(
                color: isSelected ? AppColors.blueBorder1581.withOpacity(0.26) : AppColors.white,
                width: isSelected ? 2 : 1), // Border color and width
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              category
                  .titleSemiBold(size: 14.sp, color: AppColors.countryCodeColor)
                  .symmetricPadding(horizontal: AppDimensions.smallXL.w, vertical: AppDimensions.smallXL.w),
              isSelected
                  ? Positioned(
                      right: AppDimensions.smallXL.w,
                      top: AppDimensions.smallXL.w,
                      child: SvgPicture.asset(
                        Assets.images.icCheckSelection,
                        height: AppDimensions.mediumXL.w,
                        width: AppDimensions.mediumXL.w,
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }
}
