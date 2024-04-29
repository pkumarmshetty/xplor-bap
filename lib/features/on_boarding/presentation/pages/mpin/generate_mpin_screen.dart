import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/mpin_bloc/mpin_bloc.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_welcome.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/common_pin_code_text_field_view.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/widgets/build_button.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

class GenerateMpinScreen extends StatefulWidget {
  const GenerateMpinScreen({super.key});

  @override
  State<GenerateMpinScreen> createState() => _GenerateMpinScreenState();
}

class _GenerateMpinScreenState extends State<GenerateMpinScreen> {
  final TextEditingController originalPinController = TextEditingController();
  final TextEditingController confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<MpinBloc, MpinState>(
          listener: (context, state) {
            if (state is PinSuccessState) {
              Navigator.pop(context);
              AppUtilsDialogMixin.askForMPINDialog(context);
              // AppUtils.shareFile('Sharing HSC Marksheet');
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
                          child: _buildMainContent(
                            context,
                            state,
                          ),
                        ),
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
    );
  }

  /// Builds the main content of the OTP view.
  Widget _buildMainContent(BuildContext context, MpinState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Display the welcome content with the title and subtitle.
        BlocBuilder<MpinBloc, MpinState>(
          builder: (context, state) {
            //print("Phone Number: ${context.read<OtpBloc>().phoneNumber}");
            return const WelcomeContentWidget(
              title: 'Generate MPIN',
              subTitle: 'Generate your MPIN securely for account access.',
            );
          },
        ),

        AppDimensions.large.vSpace(),

        'Enter MPIN'.titleBold(size: 14.sp),
        5.verticalSpace,

        /// Build the OTP digit field.
        CommonPinCodeTextField(
          hidePin: true,
          textEditingController: originalPinController,
          onChanged: (value) => context
              .read<MpinBloc>()
              .add(PinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
        ),
        5.verticalSpace,

        'Re-Enter'.titleBold(size: 14.sp),
        5.verticalSpace,

        /// Build the OTP digit field.
        CommonPinCodeTextField(
          hidePin: true,
          textEditingController: confirmPinController,
          onChanged: (value) => context
              .read<MpinBloc>()
              .add(PinChangedEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text)),
        ),

        if (state is PinsMisMatchedState)
          Column(
            children: [
              state.errorMessage.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
              AppDimensions.smallXL.vSpace(),
            ],
          ),
        if (state is PinFailedState)
          Column(
            children: [
              state.errorMessage.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
              AppDimensions.smallXL.vSpace(),
            ],
          ),

        ButtonWidget(
          customText: 'Verify'.titleBold(size: 14.sp, color: AppColors.white),
          onPressed: () {
            context
                .read<MpinBloc>()
                .add(ValidatePinsEvent(originalPin: originalPinController.text, confirmPin: confirmPinController.text));
          },
          isValid: state is PinCompletedState ? true : false,
        )
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }
}
