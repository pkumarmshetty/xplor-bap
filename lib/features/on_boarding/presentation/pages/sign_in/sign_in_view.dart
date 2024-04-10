import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../../utils/widgets/loading_animation.dart';
import '../../../presentation/blocs/otp_bloc/otp_bloc.dart';
import '../../../presentation/blocs/phone_bloc/phone_bloc.dart';
import '../../../presentation/widgets/build_button.dart';
import '../../../presentation/widgets/build_welcome.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/space.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../../config/services/app_services.dart';
import '../../../../../utils/app_dimensions.dart';
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

  final TextEditingController mobileNumberController = TextEditingController();

  // Inside the build method of your StatefulWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<PhoneBloc, PhoneState>(
          listener: (context, state) {
            if (state is SuccessPhoneState) {
              context.read<OtpBloc>().add(PhoneNumberSaveEvent(
                  phoneNumber: state.phoneNumber, key: state.key));
              Navigator.pushNamed(
                AppServices.navState.currentContext!,
                Routes.otp,
              );
            }
          },
          child: BlocBuilder<PhoneBloc, PhoneState>(
            builder: (context, state) {
              return Form(
                child: Stack(
                  children: [
                    CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: _buildMainContent(context, state),
                        ),
                      ],
                    ),
                    if (state is PhoneLoadingState) const LoadingAnimation(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the main content of the sign-in view.
  Widget _buildMainContent(BuildContext context, PhoneState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WelcomeContentWidget(),
        AppDimensions.large.vSpace(),
        _buildPhoneNumberForm(context),
        AppDimensions.smallXL.vSpace(),
        if (state is FailurePhoneState)
          Column(
            children: [
              state.message
                  .toString()
                  .titleSemiBold(size: 12.sp, color: AppColors.errorColor),
              AppDimensions.smallXL.vSpace(),
            ],
          ),
        _buildSuggestionTitle(),
        AppDimensions.smallXL.vSpace(),
        ButtonWidget(
          title: 'Send OTP',
          isValid: state is PhoneValidState || state is SuccessPhoneState,
          onPressed: () {
            context.read<PhoneBloc>().add(
                  PhoneSubmitEvent(
                    phone: mobileNumberController.text,
                  ),
                );
          },
        ),
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
  Widget _buildPhoneNumberForm(BuildContext context) {
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
          onInit: (val) => context
              .read<PhoneBloc>()
              .add(CountryCodeEvent(countryCode: val!)),
          onChanged: (val) {
            context.read<PhoneBloc>().add(CountryCodeEvent(countryCode: val));
            context
                .read<PhoneBloc>()
                .add(CheckPhoneEvent(phone: mobileNumberController.text));
          },
          initialSelection: 'IN',
          favorite: const ['+91'],
          showCountryOnly: false,
          showDropDownButton: false,
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
      onChanged: (val) =>
          context.read<PhoneBloc>().add(CheckPhoneEvent(phone: val.trim())),
    );
  }
}
