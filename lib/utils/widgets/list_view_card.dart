import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';

import '../app_dimensions.dart';

class CardItemView extends StatelessWidget {
  CardItemView({
    super.key,
    required this.title,
    required this.description,
    required this.callback,
    this.langCode,
    this.endChild,
    this.isSelected = false,
    this.isLastIndex = false,
  });

  final bool isSelected;
  final String title;
  final String description;
  final String? langCode;
  final Widget? endChild;
  final GestureTapCallback callback;
  final bool isLastIndex;

  @override
  Widget build(BuildContext context) {
    // Get random color from colors list

    return GestureDetector(
        onTap: callback,
        child: Container(
          margin: isLastIndex
              ? const EdgeInsets.only(top: AppDimensions.extraSmall, bottom: 2 * AppDimensions.xxlLarge)
              : const EdgeInsets.symmetric(vertical: AppDimensions.extraSmall),
          decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor.withOpacity(0.15) : Colors.transparent,
              border: Border.all(color: isSelected ? AppColors.primaryColor : AppColors.lightBlue),
              borderRadius: BorderRadius.all(Radius.circular(AppDimensions.medium.sp))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              title.titleExtraBold(color: isSelected ? AppColors.primaryColor : getColors(), size: 32.sp),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  description.titleBold(
                      color: isSelected ? AppColors.primaryColor : AppColors.blackMedium, size: 16.sp),
                  if (langCode!.isNotEmpty)
                    '($langCode)'.titleRegular(
                      size: 12.sp,
                      color: isSelected ? AppColors.primaryColor : AppColors.textColor,
                    ),
                ],
              ).symmetricPadding(horizontal: AppDimensions.medium.w)),
              endChild ??
                  Icon(
                    isSelected ? CupertinoIcons.check_mark_circled_solid : Icons.radio_button_off,
                    color: isSelected ? AppColors.primaryColor : AppColors.greyC9,
                    size: 24.sp,
                  )
            ],
          ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.mediumXL),
        ));
  }

  Color getColors() {
    final random = Random();
    final randomColorIndex = random.nextInt(colors.length); // Generate random index for colors list
    final randomColor = colors[randomColorIndex];

    return randomColor;
  }

  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.indigo,
    Colors.teal,
    Colors.pink,
  ];
}
