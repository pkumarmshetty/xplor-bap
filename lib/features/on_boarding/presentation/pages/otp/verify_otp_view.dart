import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/mapping_const.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../config/theme/theme_cubit.dart';
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

/// Widget for the sign-in view.
class VerifyOtpView extends StatefulWidget {
  const VerifyOtpView({super.key});

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

/// State class for the sign-in view.
class _VerifyOtpViewState extends State<VerifyOtpView> {
  bool isValid = false;
  final TextEditingController textEditingController = TextEditingController();
  Timer? resendTimer;
  int remainingTime = 30;

  @override
  void initState() {
    super.initState();
    context.read<PhoneBloc>().add(const CountryCodeEvent(countryCode: "+91"));
    startResendTimer();
  }

  @override
  Widget build(BuildContext context) {
    // print("build");
    return Scaffold(
      backgroundColor: appTheme().colors.white,
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
                  if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.loginFrom) == PrefConstKeys.seekerHomeKey) {
                    if (Routes.kyc == checkRouteBasedOnUserJourney()) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        checkRouteBasedOnUserJourney(),
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  } else {
                    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.focus}Done', true);
                    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.role}Done', true);
                    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.category}Done', true);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      checkRouteBasedOnUserJourney(),
                      (route) => false, // Do not allow back navigation
                    );
                  }

                  sl<SharedPreferencesHelper>()
                      .setString(PrefConstKeys.phoneNumber, context.read<OtpBloc>().phoneNumber ?? "");
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
                      SliverAppBar(
                        surfaceTintColor: AppColors.white,
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 38.w,
                            width: 38.w,
                            decoration: BoxDecoration(
                              color: AppColors.blueWith10Opacity,
                              // Set your desired background color
                              borderRadius: BorderRadius.circular(9.0), // Set your desired border radius
                            ),
                            child: SvgPicture.asset(height: 9.w, width: 9.w, Assets.images.icBack)
                                .paddingAll(padding: AppDimensions.smallXL),
                          ).singleSidePadding(left: AppDimensions.medium, top: AppDimensions.medium),
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        pinned: true,
                        floating: false,
                        snap: false,
                        // Other SliverAppBar properties as needed
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.medium,
                          vertical: kFloatingActionButtonMargin,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              AppDimensions.mediumXL.vSpace(),
                              Center(
                                child: SvgPicture.asset(
                                  height: 195.w,
                                  width: 195.w,
                                  Assets.images.verifyOtpScreenLogo,
                                ),
                              ),
                              AppDimensions.smallXL.vSpace(),
                              Center(
                                child: OnBoardingKeys.otpVerification.stringToString
                                    .titleExtraBold(size: 32.sp, color: AppColors.countryCodeColor),
                              ),
                              AppDimensions.extraSmall.vSpace(),
                              Center(
                                child:
                                    '${OnBoardingKeys.enterSixDigitOtpThatWeHaveSentTo.stringToString} ${context.read<OtpBloc>().phoneNumber}'
                                        .titleRegular(
                                            size: 14.sp, color: AppColors.grey64697a, align: TextAlign.center),
                              ),
                              AppDimensions.extraSmall.vSpace(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context); // Call method to show dialog
                                },
                                child: Center(
                                  child: OnBoardingKeys.wrongNumber.stringToString.titleSemiBold(
                                      color: AppColors.primaryColor, size: 13.sp, align: TextAlign.center),
                                ),
                              ).symmetricPadding(horizontal: AppDimensions.medium),
                              AppDimensions.mediumXL.vSpace(),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  // Border radius
                                  side: BorderSide(
                                    color: AppColors.greye8e8e8, // Border color
                                    width: 0.5, // Border width
                                  ),
                                ),
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppDimensions.smallXL.vSpace(),
                                    OnBoardingKeys.enterOtp.stringToString
                                        .titleSemiBold(color: AppColors.blue050505, size: 16.sp),
                                    AppDimensions.mediumXL.vSpace(),
                                    CommonPinCodeTextField(
                                      pinBorderColor: AppColors.primaryColor,
                                      pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
                                      isReadOnly: (state is FailureOtpState &&
                                              state.message!.isNotEmpty &&
                                              state.message!.contains(OnBoardingKeys.exceeded.stringToString))
                                          ? true
                                          : false,
                                      textEditingController: textEditingController,
                                      onChanged: (value) =>
                                          context.read<OtpBloc>().add(PhoneOtpValidatorEvent(otp: value)),
                                    ),
                                    if (state is FailureOtpState && state.message!.isNotEmpty)
                                      Column(
                                        children: [
                                          state.message
                                              .toString()
                                              .titleSemiBold(maxLine: 3, size: 12.sp, color: AppColors.errorColor),
                                          AppDimensions.smallXL.vSpace(),
                                        ],
                                      ),

                                    /// Display the resend OTP option.
                                    _resendOtp(context, state),
                                    AppDimensions.smallXL.vSpace(),
                                  ],
                                ).symmetricPadding(horizontal: AppDimensions.medium),
                              )
                            ],
                          ),
                        ),
                      ),
                      /*SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppDimensions.mediumXL.vSpace(),
                              Center(
                                child: SvgPicture.asset(
                                  height: 195.w,
                                  width: 195.w,
                                  Assets.images.verifyOtpScreenLogo,
                                ),
                              ),
                              AppDimensions.smallXL.vSpace(),
                              Center(
                                child: OnBoardingKeys
                                    .otpVerification.stringToString
                                    .titleExtraBold(
                                        size: 32.sp,
                                        color: AppColors.countryCodeColor),
                              ),
                              AppDimensions.extraSmall.vSpace(),
                              Center(
                                child:
                                    '${OnBoardingKeys.enterSixDigitOtpThatWeHaveSentTo.stringToString} ${context.read<OtpBloc>().phoneNumber}'
                                        .titleRegular(
                                            size: 14.sp,
                                            color: AppColors.grey64697a,
                                            align: TextAlign.center),
                              ),
                              AppDimensions.extraSmall.vSpace(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context); // Call method to show dialog
                                },
                                child: Center(
                                  child: OnBoardingKeys
                                      .wrongNumber.stringToString
                                      .titleSemiBold(
                                          color: AppColors.primaryColor,
                                          size: 13.sp,
                                          align: TextAlign.center),
                                ),
                              ).symmetricPadding(
                                  horizontal: AppDimensions.medium),
                              AppDimensions.mediumXL.vSpace(),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  // Border radius
                                  side: BorderSide(
                                    color: AppColors.greye8e8e8, // Border color
                                    width: 0.5, // Border width
                                  ),
                                ),
                                surfaceTintColor: Colors.white,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppDimensions.smallXL.vSpace(),
                                    OnBoardingKeys.enterOtp.stringToString
                                        .titleSemiBold(
                                            color: AppColors.blue050505,
                                            size: 16.sp),
                                    AppDimensions.mediumXL.vSpace(),
                                    CommonPinCodeTextField(
                                      pinBorderColor: AppColors.primaryColor,
                                      pinFilledColor: AppColors.primaryColor
                                          .withOpacity(0.05),
                                      isReadOnly: (state is FailureOtpState &&
                                              state.message!.isNotEmpty &&
                                              state.message!.contains(
                                                  OnBoardingKeys
                                                      .exceeded.stringToString))
                                          ? true
                                          : false,
                                      textEditingController:
                                          textEditingController,
                                      onChanged: (value) => context
                                          .read<OtpBloc>()
                                          .add(PhoneOtpValidatorEvent(
                                              otp: value)),
                                    ),
                                    if (state is FailureOtpState &&
                                        state.message!.isNotEmpty)
                                      Column(
                                        children: [
                                          state.message
                                              .toString()
                                              .titleSemiBold(
                                                  maxLine: 3,
                                                  size: 12.sp,
                                                  color: AppColors.errorColor),
                                          AppDimensions.smallXL.vSpace(),
                                        ],
                                      ),

                                    /// Display the resend OTP option.
                                    _resendOtp(context, state),
                                    AppDimensions.smallXL.vSpace(),
                                  ],
                                ).symmetricPadding(
                                    horizontal: AppDimensions.medium),
                              )
                            ],
                          ).symmetricPadding(horizontal: AppDimensions.medium),
                        ),*/
                      SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              const Spacer(),
                              CircularButton(
                                isValid: state is OtpValidState,
                                title: OnBoardingKeys.verify.stringToString,
                                onPressed: () {
                                  context.read<OtpBloc>().add(PhoneOtpVerifyEvent(otp: textEditingController.text));
                                },
                              ).symmetricPadding(
                                horizontal: AppDimensions.medium,
                                vertical: AppDimensions.large.w,
                              ),
                            ],
                          )),
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
