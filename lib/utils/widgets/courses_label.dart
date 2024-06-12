import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';
import '../extensions/font_style/font_styles.dart';

class CoursesLabel extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final bool isSelected;

  const CoursesLabel({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.isSelected = false,
  });

  @override
  State<CoursesLabel> createState() => _CoursesLabelState();
}

class _CoursesLabelState extends State<CoursesLabel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged!(widget.value);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.lightBlueProfileTiles : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: widget.label
            .titleMedium(size: 12.sp, color: widget.isSelected ? AppColors.black : AppColors.tabsUnselectedTextColor),
      ),
    );
  }
}
