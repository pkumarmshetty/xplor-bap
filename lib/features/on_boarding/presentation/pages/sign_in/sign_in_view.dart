import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_button.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_welcome.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../config/services/app_services.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../domain/entities/on_boarding_entity.dart';
import '../../widgets/phone_number_formatter.dart';

/// Widget for the sign-in view.
class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

/// State class for the sign-in view.
class _SignInViewState extends State<SignInView> {
  bool isValid = false;
  String countryCode = "+91";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController mobileNumberController = TextEditingController();

  /// Validates the phone number input.
  void _validatePhoneNumber(String phoneNumber) {
    // Simple validation example: Check if phone number is not empty
    setState(() {
      isValid = phoneNumber.isNotEmpty &&
          phoneNumber.replaceAll(' ', '').length == 10;
    });
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

  /// Builds the main content of the sign-in view.
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WelcomeContentWidget(),
        AppDimensions.large.vSpace(),
        _buildPhoneNumberForm(),
        AppDimensions.smallXL.vSpace(),
        _buildSuggestionTitle(),
        AppDimensions.smallXL.vSpace(),
        ButtonWidget(
          title: 'Send OTP',
          isValid: isValid,
          onPressed: () {
            Navigator.pushNamed(
              AppServices.navState.currentContext!,
              Routes.otp,
              arguments: OnBoardingEntity(
                phoneNumber: mobileNumberController.text,
                countryCode: countryCode,
              ),
            );
          },
        )
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }

  /// Builds the title for the suggestion.
  Widget _buildSuggestionTitle() {
    return "You will receive an SMS verification that may apply message and data rates."
        .titleRegular(size: 12.sp, color: AppColors.subTitleText);
  }

  /// Builds the phone number input form field.
  Widget _buildPhoneNumberForm() {
    return TextFormField(
      controller: mobileNumberController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        LengthLimitingTextInputFormatter(12),
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
        PhoneNumberFormatter(),
      ],
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        hintStyle:
            GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600),
        prefixIcon: CountryCodePicker(
          onChanged: (countryCode) {
            setState(() {
              this.countryCode = countryCode.dialCode ?? "+91";
            });
          },
          initialSelection: 'IN',
          favorite: const ['+91'],
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          borderSide: BorderSide(color: AppColors.hintColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0), // Border radius
          borderSide: const BorderSide(
              color: AppColors.primaryColor), // Border color when focused
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: AppDimensions.medium), // Height of the TextFormField
      ),
      onChanged: _validatePhoneNumber,
    );
  }
}
