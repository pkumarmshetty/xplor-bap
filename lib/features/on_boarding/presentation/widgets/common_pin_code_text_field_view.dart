import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class CommonPinCodeTextField extends StatelessWidget {
  final TextEditingController? textEditingController;
  final Function(String value)? onChanged;
  const CommonPinCodeTextField({super.key, this.textEditingController, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Create PinCodeTextField widget
    return PinCodeTextField(
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
      ],
      length: 6,
      obscureText: false,
      autoFocus: false,
      animationType: AnimationType.fade,
      /*validator: (val) {
        // Validate pin code
        if (val!.isEmpty) {
          return "Please enter otp";
        }
        if (val.length < 5) {
          return "Please enter 6 digits otp";
        }

        return null;
      },*/
      errorTextSpace: AppDimensions.mediumXL,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 45.w,
        fieldWidth: 45.w,
        borderWidth: 1.w,
        fieldOuterPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.extraSmall,
        ),
        inactiveColor: AppColors.hintColor,
        inactiveFillColor: Colors.transparent,
        activeFillColor: Colors.transparent,
        activeColor: AppColors.primaryColor,
        selectedFillColor: Colors.transparent,
        selectedColor: AppColors.primaryColor,
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
    );
  }
}
