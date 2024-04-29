import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_colors.dart';
import '../extensions/font_style/font_styles.dart';
import '../app_dimensions.dart';
import '../utils.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    this.hintText,
    this.onChanged,
    this.controller,
    this.validator,
    this.onPressed,
    this.inputFormatters,
    this.suffixIcon,
    this.onTap,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.obscureText = true,
    this.prefixIcon,
    this.onFieldSubmitted,
  });

  final String? hintText;
  final String label;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator? validator;
  final TextInputType? inputType;
  final bool isPassword, obscureText, readOnly;
  final VoidCallback? onPressed, onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != "") label.titleBold(size: 14.sp),
        TextFormField(
          maxLines: 3,
          minLines: 1,
          controller: controller,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          readOnly: readOnly,
          keyboardType: inputType,
          onTap: onTap,
          inputFormatters: inputFormatters,
          obscureText: isPassword ? obscureText : false,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w400, fontSize: 14.sp, color: AppColors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 14.sp, horizontal: AppDimensions.smallXL.sp),
            hintText: hintText,
            hintStyle: GoogleFonts.manrope(fontWeight: FontWeight.w400, fontSize: 14.sp, color: AppColors.hintColor),
            prefixIcon: prefixIcon,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: onPressed,
                  )
                : suffixIcon,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: AppColors.hintColor),
              borderRadius: BorderRadius.circular(AppDimensions.small),
            ),
          ),
        ).symmetricPadding(vertical: AppDimensions.small.sp)
      ],
    );
  }
}
