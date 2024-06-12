import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/mpin_bloc/mpin_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/circluar_button.dart';
import 'package:xplor/utils/common_top_header.dart';

import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';

class GenerateMpinScreen extends StatefulWidget {
  const GenerateMpinScreen({super.key});

  @override
  State<GenerateMpinScreen> createState() => _GenerateMpinScreenState();
}

class _GenerateMpinScreenState extends State<GenerateMpinScreen> {
  final TextEditingController originalPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MpinBloc>().add(const PinInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppBackgroundDecoration(
          child: BlocListener<MpinBloc, MpinState>(
            listener: (context, state) {
              if (state is PinSuccessState) {
                Navigator.pop(context);
                AppUtilsDialogMixin.askForMPINDialog(context);
              }
            },
            child: BlocBuilder<MpinBloc, MpinState>(
              builder: (context, state) {
                return Form(
                  // key: state.formKey,
                  child: Stack(
                    children: [
                      CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                CommonTopHeader(
                                    title: GenerateMpinKeys.generateMpin.stringToString,
                                    backgroundColor: Colors.transparent,
                                    dividerColor: AppColors.hintColor,
                                    onBackButtonPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                _buildMainContent(
                                  context,
                                  state,
                                ),
                              ],
                            ),
                          ),
                          SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  CircularButton(
                                    onPressed: () {
                                      context.read<MpinBloc>().add(ValidatePinsEvent(
                                          originalPin: originalPinController.text,
                                          confirmPin: confirmPinController.text));
                                    },
                                    isValid: state is PinCompletedState ? true : false,
                                    title: GenerateMpinKeys.verify.stringToString,
                                  ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.large.w),
                                ],
                              ))
                        ],
                      ),
                      if (state is PinsLoadingState) const LoadingAnimation(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the main content of the OTP view.
  Widget _buildMainContent(BuildContext context, MpinState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppDimensions.smallXXL.vSpace(),

        /// Display the welcome content with the title and subtitle.
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.images.generateMpin),
            GenerateMpinKeys.generateMpin.stringToString.titleExtraBold(size: 32.sp),
            AppDimensions.extraSmall.vSpace(),
            GenerateMpinKeys.generateMpinSecurelyForAccountAccess.stringToString
                .titleRegular(size: 14.sp, color: AppColors.grey64697a, align: TextAlign.center),
          ],
        ),

        AppDimensions.large.vSpace(),

        Container(
          padding: const EdgeInsets.all(AppDimensions.smallXL),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.searchShadowColor.withOpacity(0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.medium),
            boxShadow: const [
              BoxShadow(
                color: AppColors.searchShadowColor, // Shadow color
                offset: Offset(0, 1), // Offset
                blurRadius: 1, // Blur radius
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenerateMpinKeys.enterMPin.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
              4.verticalSpace,

              /// Build the OTP digit field.
              CommonPinCodeTextField(
                hidePin: true,
                height: 48.sp,
                pinBorderColor: AppColors.primaryColor,
                pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
                obscureIcon: SvgPicture.asset(Assets.images.obscuringIcon),
                textEditingController: originalPinController,
                onChanged: (value) => context.read<MpinBloc>().add(
                    PinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
              ),

              GenerateMpinKeys.reEnter.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
              4.verticalSpace,

              /// Build the OTP digit field.
              CommonPinCodeTextField(
                obscureIcon: SvgPicture.asset(Assets.images.obscuringIcon),
                hidePin: true,
                height: 48.sp,
                pinBorderColor: AppColors.primaryColor,
                pinFilledColor: AppColors.primaryColor.withOpacity(0.05),
                textEditingController: confirmPinController,
                onChanged: (value) => context.read<MpinBloc>().add(
                    PinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
              ),
              (state is PinsMisMatchedState)
                  ? Column(
                      children: [
                        state.errorMessage.toString().titleSemiBold(
                            size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible),
                        AppDimensions.smallXL.vSpace(),
                      ],
                    )
                  : Container(),

              (state is PinFailedState)
                  ? Column(
                      children: [
                        state.errorMessage.toString().titleSemiBold(
                            size: 12.sp, color: AppColors.errorColor, maxLine: 3, overflow: TextOverflow.visible),
                        AppDimensions.smallXL.vSpace(),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
        AppDimensions.large.vSpace(),
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.medium,
    );
  }
}
