import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';

class CardTitleWidget extends StatefulWidget {
  const CardTitleWidget({
    super.key,
    required this.title,
    required this.selectedLocation,
  });

  final String title;
  final String? selectedLocation;

  @override
  State<CardTitleWidget> createState() => _CardTitleWidgetState();
}

class _CardTitleWidgetState extends State<CardTitleWidget> {
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        widget.title.titleBold(size: 18.sp, color: AppColors.black1a1d1f),
        Container(
            height: 40.w,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.checkBoxDisableColor),
                borderRadius: BorderRadius.circular(AppDimensions.smallXL)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: SizedBox(
                  width: 100.w,
                  child: HomeKeys.sixWeeks.stringToString
                      .titleSemiBold(color: AppColors.greyTextColor, size: AppDimensions.smallXXL.sp, maxLine: 1),
                ),
                value: _selectedLocation,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.greyTextColor,
                ),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                items: [HomeKeys.lastSixWeeks.stringToString, HomeKeys.lastNineWeeks.stringToString].map((location) {
                  return DropdownMenuItem(
                    value: location,
                    child: SizedBox(
                      width: 100.w,
                      child: location.titleSemiBold(
                          color: AppColors.greyTextColor, size: AppDimensions.smallXXL.sp, maxLine: 1),
                    ),
                  );
                }).toList(),
              ),
            ))
      ],
    );
  }
}
