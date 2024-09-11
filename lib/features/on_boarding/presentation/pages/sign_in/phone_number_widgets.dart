part of 'phone_number_view.dart';

bool isValid = false;
String? countryCode;
String? countryDialCode;

TextEditingController mobileNumberController = TextEditingController();

/// Builds the title for the suggestion.
Widget _buildSuggestionTitle() {
  return OnBoardingKeys.otpTopHeaderMessage.stringToString.titleRegular(size: 12.sp, color: AppColors.subTitleText);
}

/// Builds the phone number input form field.
Widget _buildPhoneNumberForm(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.smallXL), border: Border.all(color: AppColors.greye8e8e8)),
    child: IntlPhoneField(
      controller: mobileNumberController,
      pickerDialogStyle: PickerDialogStyle(
          countryCodeStyle:
              GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
          countryNameStyle:
              GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
          listTileDivider: const SizedBox(),
          listTilePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium, vertical: 0),
          padding: const EdgeInsets.all(AppDimensions.smallXL),
          searchFieldPadding: const EdgeInsets.only(
              left: AppDimensions.small,
              right: AppDimensions.small,
              top: AppDimensions.mediumXL,
              bottom: AppDimensions.smallXL),
          searchFieldInputDecoration: InputDecoration(
              hintText: '${OnBoardingKeys.searchAnyCountry.stringToString}...',
              hintStyle:
                  GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
              prefixIcon: Icon(
                Icons.search,
                size: AppDimensions.large.w,
              ),
              suffixIcon: GestureDetector(
                child: const Icon(Icons.cancel),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )),
          width: double.infinity),
      flagsButtonPadding: const EdgeInsets.all(AppDimensions.small),
      dropdownIconPosition: IconPosition.trailing,
      dropdownTextStyle:
          GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
      style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
      onCountryChanged: (Country country) {
        countryDialCode = "+${country.dialCode}";
        context.read<PhoneBloc>().add(CountryCodeEvent(countryCode: "+${country.dialCode}"));
        context.read<PhoneBloc>().add(CheckPhoneEvent(phone: mobileNumberController.text));
      },
      disableLengthCheck: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
        FilteringTextInputFormatter.digitsOnly, // Allow only digits
        PhoneNumberFormatter(),
      ],
      dropdownIcon: Icon(
        Icons.keyboard_arrow_down,
        size: 22.w,
        color: AppColors.countryCodeColor,
      ),
      decoration: InputDecoration(
        hintText: OnBoardingKeys.enterMobileNumber.stringToString,

        hintStyle: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.greye8e8e81),

        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.smallXL), // Border radius
          borderSide: const BorderSide(color: AppColors.primaryColor), // Border color when focused
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: AppDimensions.medium), // Height of the TextFormField
      ),
      initialCountryCode: countryCode,
      onChanged: (phone) {
        context.read<PhoneBloc>().add(CountryCodeEvent(countryCode: phone.countryCode));
        context.read<PhoneBloc>().add(CheckPhoneEvent(phone: phone.number));
      },
    ),
  );
}
