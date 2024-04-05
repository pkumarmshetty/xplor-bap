import 'package:flutter/material.dart';

///
import 'package:xplor/features/on_boarding/presentation/widgets/build_button.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_custom_checkbox.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_single_selection_wallet.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_welcome.dart';
import 'package:xplor/utils/custom_confirmation_dialog.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

/// Importing necessary paths and services
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/custom_dialog_view.dart';

/// Definition of the CompleteKYCView widget
class CompleteKYCView extends StatefulWidget {
  const CompleteKYCView({super.key});

  @override
  State<CompleteKYCView> createState() => _CompleteKYCViewState();
}

/// State class for CompleteKYCView widget
class _CompleteKYCViewState extends State<CompleteKYCView> {
  bool isValid = false;
  bool isChecked = false;
  int selectedIndex = -1;

  /// Method to set the selected index
  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeContentWidget(
                  title: 'Complete your KYC', subTitle: 'Select one to proceed')
              .symmetricPadding(
            horizontal: AppDimensions.large,
          ),
          AppDimensions.large.vSpace(),
          Expanded(
              child: SingleSelectionWallet(
            selectedIndex: selectedIndex,
            onIndexChanged: setSelectedIndex,
          )),
          _bottomViewContent(context)
        ],
      )),
    );
  }

  /// Widget for building the bottom view content
  Widget _bottomViewContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        agreeConditionWidget(),
        AppDimensions.smallXL.vSpace(),
        ButtonWidget(
          title: 'Continue',
          isValid: isValid && selectedIndex != -1,
          onPressed: () {
            _showKYCConfirmationDialog(context);
          },
        ),
        AppDimensions.mediumXL.vSpace(),
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }

  /// Widget for the agree condition
  Widget agreeConditionWidget() {
    return Row(
      children: <Widget>[
        CustomCheckbox(
          onChanged: (isChecked) {
            setState(() {
              isValid = isChecked;
            });
          },
        ),
        AppDimensions.small.hSpace(),
        GestureDetector(
          onTap: () {
            _showConsentDialog(context); // Call method to show dialog
          },
          child: RichText(
            text: TextSpan(
              children: [
                'I hereby confirm my '.textSpanRegular(),
                'consent to authorize'
                    .textSpanSemiBold(decoration: TextDecoration.underline),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Method to show the consent dialog
  void _showConsentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogView(
          title: 'Consent to Authorize',
          message:
              'We are committed to protecting your privacy and ensuring the security of your personal data. We only share minimum necessary data with trusted third parties for authentication purposes, and your data will never be shared for any other purposes without your explicit consent. Your personal data is used solely for providing personalized journeys and recommendations within the application.',
          onConfirmPressed: () {
            // Implement the action when OK button is pressed
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: 'KYC Successful!',
          message: 'You have been successfully verified.',
          onConfirmPressed: () {
            // Implement the action when OK button is pressed
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }
}
