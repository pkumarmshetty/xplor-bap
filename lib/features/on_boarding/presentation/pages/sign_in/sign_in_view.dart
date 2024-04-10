import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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

  @override
  void initState() {
    context.read<PhoneBloc>().add(const CountryCodeEvent(countryCode: "+91"));
    super.initState();
  }

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
        _buildPhoneNumberForm(),
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
  Widget _buildPhoneNumberForm() {
    return IntlPhoneField(
      controller: mobileNumberController,
      pickerDialogStyle: PickerDialogStyle(
          countryCodeStyle: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.countryCodeColor),
          countryNameStyle: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.countryCodeColor),
          listTileDivider: const SizedBox(),
          listTilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          padding: const EdgeInsets.all(12),
          searchFieldPadding:
              const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
          searchFieldInputDecoration: InputDecoration(
              hintText: "Search any country...",
              hintStyle: GoogleFonts.manrope(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.countryCodeColor),
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
              ),
              suffixIcon: GestureDetector(
                child: const Icon(Icons.cancel),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )),
          width: double.infinity),
      flagsButtonPadding: const EdgeInsets.all(8),
      dropdownIconPosition: IconPosition.trailing,
      dropdownTextStyle: GoogleFonts.manrope(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.countryCodeColor),
      style: GoogleFonts.manrope(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.countryCodeColor),
      onCountryChanged: (Country country) {
        context
            .read<PhoneBloc>()
            .add(CountryCodeEvent(countryCode: "+${country.dialCode}"));
        context
            .read<PhoneBloc>()
            .add(CheckPhoneEvent(phone: mobileNumberController.text));
      },
      disableLengthCheck: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(12),
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
        PhoneNumberFormatter(),
      ],
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down,
        size: 22.w,
        color: AppColors.countryCodeColor,
      ),
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        hintStyle:
            GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400),

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
      initialCountryCode: 'IN',
      onChanged: (phone) =>
          context.read<PhoneBloc>().add(CheckPhoneEvent(phone: phone.number)),
    );
  }
}
