import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../extensions/string_to_string.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

class SearchTextFieldWidget extends StatelessWidget {
  const SearchTextFieldWidget({
    super.key,
    this.onChanged,
    this.onSearch,
    this.controller,
  });

  final Function(String)? onChanged;
  final Function(String)? onSearch;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: controller,
      prefixIcon: Container(),
      suffixMode: OverlayVisibilityMode.never,
      onChanged: onChanged,
      onSubmitted: onSearch != null ? (String value) => onSearch!(value) : null,
      placeholder: SeekerHomeKeys.typeSomethingHere.stringToString,
      placeholderStyle: GoogleFonts.manrope(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.tabsUnselectedTextColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.medium,
        horizontal: AppDimensions.smallXL,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadowColor,
            offset: Offset(0, 3),
            blurStyle: BlurStyle.outer,
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(AppDimensions.medium),
      ),
    );
  }
}
