import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

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
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
            side: BorderSide(
                color: isSelected ? AppColors.blueBorder1581.withOpacity(0.26) : AppColors.white,
                width: isSelected ? 2 : 1), // Border color and width
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              category
                  .titleSemiBold(size: 14.sp, color: AppColors.countryCodeColor)
                  .symmetricPadding(horizontal: 10.w, vertical: 10.w),
              isSelected
                  ? Positioned(
                      right: 10.w,
                      top: 10.w,
                      child: SvgPicture.asset(
                        Assets.images.icCheckSelection,
                        height: 20.w,
                        width: 20.w,
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }
}
