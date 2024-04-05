import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/conversion.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../../config/services/app_services.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../domain/entities/on_boarding_entity.dart';
import '../../widgets/build_button.dart';
import '../../widgets/build_welcome.dart';

/// This class represents the OTP verification view.
class OtpView extends StatefulWidget {
  const OtpView({super.key, this.loginEntity});

  final OnBoardingEntity? loginEntity;

  @override
  State<OtpView> createState() => _OtpViewState();
}

/// The state class for the OTP view.
class _OtpViewState extends State<OtpView> {
  bool isValid = false;
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Timer resendTimer;
  int remainingTime = 30;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _buildMainContent(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the main content of the OTP view.
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Display the welcome content with the title and subtitle.
        WelcomeContentWidget(
          title: 'OTP Verification',
          subTitle:
              'Enter the 6 digit OTP that we have sent to ${Conversion.maskPhoneNumber(widget.loginEntity!.countryCode!, widget.loginEntity!.phoneNumber!)}',
        ),
        AppDimensions.large.vSpace(),

        /// Build the OTP digit field.
        CommonPinCodeTextField(
          textEditingController: textEditingController,
          onChanged: (value) {
            setState(() {
              isValid = value.length == 6;
            });
          },
        ),

        /// Display the resend OTP option.
        _resendOtp(),
        AppDimensions.smallXL.vSpace(),

        /// Build the verification button.
        ButtonWidget(
          title: 'Verify',
          isValid: isValid,
          onPressed: () {
            Navigator.pushNamed(
              AppServices.navState.currentContext!,
              Routes.chooseRole,
            );
          },
        )
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }

  /// Builds the resend OTP option.
  Widget _resendOtp() {
    return GestureDetector(
      child: remainingTime > 0
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ('Send code again in ').titleBold(
                size: 12.sp,
                color: AppColors.subTitleText,
              ),
              (Conversion.formatSeconds(remainingTime))
                  .titleRegular(size: 12.sp, color: AppColors.subTitleText)
            ])
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ("I didn’t receive to code. ")
                  .titleMedium(size: 12.sp, color: AppColors.subTitleText),
              ('Resend').titleBold(size: 12.sp, color: AppColors.primaryColor)
            ]),
      onTap: () {
        if (remainingTime == 0) {
          textEditingController.clear();
          setState(() {
            remainingTime = 30;
          });
          startResendTimer();
        }
      },
    );
  }

  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
  }

  /// Starts the timer for OTP resend.
  void startResendTimer() {
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        resendTimer.cancel();
      }
    });
  }
}
