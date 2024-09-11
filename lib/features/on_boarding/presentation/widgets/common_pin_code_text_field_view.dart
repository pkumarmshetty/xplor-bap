import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class CommonPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final bool? hidePin;
  final bool? isReadOnly;
  final Color? pinBorderColor;
  final Color? pinFilledColor;
  final double? width;
  final double? height;
  final Function(String value)? onChanged;
  final Widget? obscureIcon;

  const CommonPinCodeTextField({
    super.key,
    this.textEditingController,
    this.onChanged,
    this.hidePin,
    this.pinBorderColor,
    this.pinFilledColor,
    this.isReadOnly,
    this.width,
    this.height,
    this.obscureIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Create PinCodeTextField widget
    return PinCodeTextField(
      cursorColor: AppColors.primaryColor,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      length: 6,
      hintCharacter: '0',
      obscureText: hidePin ?? false,
      obscuringWidget: hidePin ?? false
          ? obscureIcon ??
              SvgPicture.asset(
                Assets.images.icStarPin,
              )
          : null,
      autoFocus: false,
      animationType: AnimationType.fade,
      errorTextSpace: AppDimensions.mediumXL,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: height ?? 45.w,
        fieldWidth: width ?? 45.w,
        borderWidth: 1.w,
        fieldOuterPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.extraSmall,
        ),
        inactiveColor: AppColors.greye8e8e8,
        inactiveFillColor: AppColors.white,
        activeFillColor: pinFilledColor ?? Colors.transparent,
        activeColor: pinBorderColor ?? AppColors.primaryColor,
        selectedFillColor: pinFilledColor ?? Colors.transparent,
        selectedColor: pinBorderColor ?? AppColors.primaryColor,
        //textColor: Colors.black,
      ),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      controller: textEditingController,
      onCompleted: (v) {},
      onChanged: onChanged,
      beforeTextPaste: (text) {
        return true;
      },
      appContext: context,
      readOnly: isReadOnly ?? false,
      textStyle: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 14.sp, color: AppColors.countryCodeColor),
    );
  }
}
