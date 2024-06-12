import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

import '../../../../utils/app_colors.dart';

class TagListWidgets extends StatelessWidget {
  final List<String> tags;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const TagListWidgets({super.key, this.tags = const ["Tags1", "Tags2"], this.padding, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allow horizontal scrolling
        child: Wrap(
          spacing: 8.0, // Spacing between tags
          runSpacing: 8.0, // Spacing between rows of tags
          children: tags.map((tag) => _buildTagChip(tag)).toList(),
        ));
  }

  Widget _buildTagChip(String tag) {
    return Container(
      height: AppDimensions.medium.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // Set the border radius
        color: AppColors.lightBlue6f0fa, // Set the background color
      ),
      child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10.0),
          child: tag.titleSemiBold(size: fontSize ?? 8.sp)),
    );
  }
}
