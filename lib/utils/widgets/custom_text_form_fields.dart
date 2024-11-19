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
        if (label != "") label.titleBold(size: 14.sp, color: AppColors.grey64697a),
        Container(
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(color: Colors.transparent, boxShadow: [
            BoxShadow(
              color: AppColors.grey100,
              offset: Offset(0, 10),
              blurRadius: 30,
            )
          ]),
          child: TextFormField(
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
              filled: true,
              fillColor: AppColors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 16.sp, horizontal: AppDimensions.smallXL.sp),
              hintText: hintText,
              hintStyle: GoogleFonts.manrope(fontWeight: FontWeight.w400, fontSize: 14.sp, color: AppColors.grey200),
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
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.small),
                borderSide: const BorderSide(
                  color: AppColors.grey100,
                  width: 1.0, // Border width
                ),
              ),
            ),
          ).symmetricPadding(vertical: AppDimensions.small.sp),
        )
      ],
    );
  }
}
