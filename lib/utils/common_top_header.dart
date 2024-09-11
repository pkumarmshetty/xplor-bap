import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'extensions/font_style/font_styles.dart';
import 'utils.dart';
import 'widgets/common_back_button.dart';

class CommonTopHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackButtonPressed;
  final bool isTitleOnly;
  final Color? dividerColor;
  final Color? backgroundColor;
  final Widget? suffixWidget;

  const CommonTopHeader(
      {super.key,
      required this.title,
      required this.onBackButtonPressed,
      this.isTitleOnly = false,
      this.dividerColor,
      this.suffixWidget,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppDimensions.small.verticalSpace,
            Stack(
              alignment: Alignment.centerLeft,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //alignment: Alignment.centerLeft,
              children: [
                if (!isTitleOnly) CommonBackButton(onBackPressed: onBackButtonPressed),
                Center(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: title.titleExtraBoldWithDots(
                        color: AppColors.countryCodeColor,
                        maxLine: 1,
                        size: 24.sp,
                        align: TextAlign.center,
                      )).singleSidePadding(left: 0),
                ),
                if (!isTitleOnly)
                  Align(
                    alignment: Alignment.centerRight,
                    child: suffixWidget,
                  )
              ],
            ).symmetricPadding(vertical: isTitleOnly ? AppDimensions.medium : 0),
            /*   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //alignment: Alignment.centerLeft,
              children: [
                if (!isTitleOnly)
                  CommonBackButton(onBackPressed: onBackButtonPressed),
                Expanded(
                    child: Center(child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: "jhhhjghj"
                          .titleExtraBoldWithDots(
                        color: AppColors.countryCodeColor,
                        maxLine: 1,
                        size: 24.sp,
                        align: TextAlign.center,
                      )
                          .singleSidePadding(
                        */ /* left: !isTitleOnly
                              ? suffixWidget == null
                                  ? 60.sp
                                  : 16.sp
                              : 0*/ /*),
                    )),),
                    if (!isTitleOnly) suffixWidget ?? Container(),
              ],
            ).symmetricPadding(
                vertical: isTitleOnly ? AppDimensions.medium : 0),*/
            Divider(
              color: dividerColor ?? AppColors.primaryColor,
              height: 2.0,
            )
          ],
        ),
      ),
    );
  }
}
