import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/mapping_const.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/check_route.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/circluar_button.dart';
import '../../../../../utils/extensions/conversion.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../../presentation/blocs/otp_bloc/otp_bloc.dart';
import '../../../presentation/blocs/phone_bloc/phone_bloc.dart';
import '../../widgets/common_pin_code_text_field_view.dart';

part 'verify_otp_slivers.dart';
part 'verify_otp_widgets.dart';

/// Widget for the sign-in view.
class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({super.key});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

/// State class for the sign-in view.
class _VerifyOtpViewState extends State<VerifyOtpView> {
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<PhoneBloc>().add(const CountryCodeEvent(countryCode: "+91"));
    startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AppBackgroundDecoration(
        child: SafeArea(
            child: MultiBlocListener(
          listeners: [
            BlocListener<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state is SuccessOtpState) {
                  var module =
                      (sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedRole) == PrefConstKeys.seekerKey)
                          ? seekerHomeModule
                          : homeModule;
                  context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
                      langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
                      moduleTypes: module,
                      isNavigation: true));
                }
              },
            ),
            BlocListener<TranslationBloc, TranslateState>(
              listener: (context, state) {
                if (state is TranslationLoaded && state.isNavigation) {
                  startNavigation(context);
                }
              },
            ),
          ],
          child: BlocBuilder<OtpBloc, OtpState>(
            builder: (context, state) {
              return Stack(
                children: [
                  CustomScrollView(
                    slivers: <Widget>[
                      verifyOtpSliverAppBar(context),
                      verifyOtpSliverPadding(
                          context,
                          state,
                          _resendOtp(
                            context,
                            state,
                          ),
                          textEditingController),
                      verifyOtpSliverFillRemaining(context, state, textEditingController),
                    ],
                  ),
                  if (state is OtpLoadingState || state is SuccessOtpState) const LoadingAnimation(),
                ],
              );
            },
          ),
        )),
      ),
    );
  }

  /// Builds the resend OTP option.
  Widget _resendOtp(BuildContext context, OtpState state) {
    return GestureDetector(
      child: remainingTime > 0
          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              '${OnBoardingKeys.sendCodeAgainIn.stringToString} '.titleRegular(
                size: 12.sp,
                color: AppColors.subTitleText,
              ),
              (Conversion.formatSeconds(remainingTime)).titleRegular(size: 12.sp, color: AppColors.subTitleText)
            ])
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              '${OnBoardingKeys.didntReceiveCode.stringToString} '
                  .titleMedium(size: 12.sp, color: AppColors.subTitleText),
              OnBoardingKeys.resend.stringToString.titleSemiBold(size: 12.sp, color: AppColors.primaryColor)
            ]),
      onTap: () {
        if (remainingTime == 0) {
          textEditingController.clear();
          context.read<OtpBloc>().add(const SendOtpEvent());
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
    resendTimer?.cancel();
    super.dispose();
  }

  /// Starts the timer for OTP resend.
  void startResendTimer() {
    if (resendTimer != null) {
      resendTimer?.cancel();
    }
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        resendTimer?.cancel();
      }
    });
  }
}
