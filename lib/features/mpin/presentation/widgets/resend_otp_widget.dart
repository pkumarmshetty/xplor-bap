import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/conversion.dart';
import '../../../multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';
import '../blocs/reset_mpin_bloc.dart';

class ResendOtpWidget extends StatefulWidget {
  final int resendOtpInSeconds;
  final TextEditingController otpController;
  final Function() startResendTimer;

  const ResendOtpWidget({
    super.key,
    required this.resendOtpInSeconds,
    required this.otpController,
    required this.startResendTimer,
  });

  @override
  State<ResendOtpWidget> createState() => _ResendOtpWidgetState();
}

class _ResendOtpWidgetState extends State<ResendOtpWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.resendOtpInSeconds > 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                '${GenerateMpinKeys.sendCodeAgainIn.stringToString} '.titleBold(
                  size: 12.sp,
                  color: AppColors.subTitleText,
                ),
                (Conversion.formatSeconds(widget.resendOtpInSeconds))
                    .titleRegular(size: 12.sp, color: AppColors.subTitleText)
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                '${GenerateMpinKeys.iDidntReceiveCode.stringToString} '
                    .titleMedium(size: 12.sp, color: AppColors.subTitleText),
                GenerateMpinKeys.resend.stringToString.titleBold(size: 12.sp, color: AppColors.primaryColor)
              ],
            ),
      onTap: () {
        if (widget.resendOtpInSeconds == 0) {
          widget.otpController.clear();
          context.read<ResetMpinBloc>().add(ResetMpinOtpEvent());
          widget.startResendTimer();
        }
      },
    ).symmetricPadding(
      horizontal: AppDimensions.medium,
    );
  }
}
