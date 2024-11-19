import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class CustomCheckbox extends StatefulWidget {
  final Function(bool isChecked) onChanged;
  final bool isChecked;

  const CustomCheckbox({super.key, required this.isChecked, required this.onChanged});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    isChecked = widget.isChecked;
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !widget.isChecked;
          widget.onChanged(isChecked);

          /// Notify parent class about the change
        });
      },
      child: Container(
        width: AppDimensions.large.w,
        height: AppDimensions.large.w,
        decoration: BoxDecoration(
          border: Border.all(
            color: isChecked ? AppColors.primaryColor : AppColors.checkBoxDisableColor,

            /// Border color
          ),
          borderRadius: BorderRadius.circular(6.0),

          /// Adjust border radius as needed
          color: Colors.transparent,

          /// Background color
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                size: AppDimensions.mediumXL.w,

                /// Adjust check mark size as needed
                color: AppColors.primaryColor,

                /// Check mark color
              )
            : null,
      ),
    );
  }
}
