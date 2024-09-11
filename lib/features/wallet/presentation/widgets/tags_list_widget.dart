import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/app_colors.dart';

/// A widget that displays a list of tags horizontally, allowing for scrolling if the tags overflow.
///
/// The `TagListWidgets` class is a stateless widget designed to display a series of tags in a horizontal scrollable view.
class TagListWidgets extends StatelessWidget {
  /// The list of tags to display.
  final List<String> tags;

  /// The padding for each tag chip. Optional, defaults to horizontal padding of 10.0 if not provided.
  final EdgeInsetsGeometry? padding;

  /// The font size of the tag text. Optional, defaults to a small size defined by `AppDimensions.small.sp`.
  final double? fontSize;

  const TagListWidgets({
    super.key,
    this.tags = const ["Tags1", "Tags2"],
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Allow horizontal scrolling
      child: Wrap(
        spacing: AppDimensions.small, // Spacing between tags
        runSpacing: AppDimensions.small, // Spacing between rows of tags
        children: tags.map((tag) => _buildTagChip(tag)).toList(),
      ),
    );
  }

  /// Builds an individual tag chip with a given tag text.
  Widget _buildTagChip(String tag) {
    return Container(
      height: AppDimensions.medium.w, // Set the height of the chip
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Set the border radius
        color: AppColors.lightBlue6f0fa, // Set the background color
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 10.0),
        // Default padding if not provided
        child: tag.titleSemiBold(size: fontSize ?? AppDimensions.small.sp), // Display the tag text with styling
      ),
    );
  }
}
