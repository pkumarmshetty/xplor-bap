import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';

/// Widget to display and manage phone number input in the profile screen.
class PhoneNumberWidget extends StatefulWidget {
  /// Country code of the phone number.
  final String countryCode;

  /// Phone number without the country code.
  final String phoneNumber;

  /// Creates an instance of `PhoneNumberWidget`.
  const PhoneNumberWidget({
    super.key,
    required this.countryCode,
    required this.phoneNumber,
  });

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  /// Controller to manage the text input for the phone number.
  TextEditingController mobileNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text field with the phone number, excluding the country code.
    mobileNumberController.text = widget.phoneNumber.replaceAll(widget.countryCode, "");
  }

  @override
  void dispose() {
    // Dispose of the text controller to free up resources.
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the label for the phone number input.
        ProfileKeys.mobileNo.stringToString.titleBold(
          size: AppDimensions.smallXXL.sp, // Set text size.
          color: AppColors.grey64697a, // Set text color.
        ),
        AppDimensions.smallXL.verticalSpace,
        // Add vertical space.

        // Container to hold the phone number input field.
        Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: AppColors.grey100, // Shadow color.
                offset: Offset(0, 10), // Shadow position.
                blurRadius: 30, // Blur effect.
              )
            ],
          ),

          // IntlPhoneField provides phone number input with country code.
          child: IntlPhoneField(
            enabled: false,
            // Disable the input field for editing.
            controller: mobileNumberController,
            // Attach the text controller.

            // Customize the appearance and behavior of the country picker dialog.
            pickerDialogStyle: PickerDialogStyle(
              backgroundColor: Colors.white,
              // Set the background color.

              // Style for the country code text.
              countryCodeStyle: GoogleFonts.manrope(
                fontSize: AppDimensions.smallXL.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.countryCodeColor,
              ),

              // Style for the country name text.
              countryNameStyle: GoogleFonts.manrope(
                fontSize: AppDimensions.smallXL.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.countryCodeColor,
              ),
              listTileDivider: const SizedBox(),
              // No divider between list items.
              listTilePadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium, vertical: 0),
              padding: const EdgeInsets.all(AppDimensions.smallXL),

              // Customize the search field in the dialog.
              searchFieldPadding: const EdgeInsets.only(
                left: AppDimensions.small,
                right: AppDimensions.small,
                top: AppDimensions.mediumXL,
                bottom: AppDimensions.small,
              ),
              searchFieldInputDecoration: InputDecoration(
                hintStyle: GoogleFonts.manrope(
                  fontSize: AppDimensions.smallXL.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.countryCodeColor,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: AppDimensions.large,
                ),
                suffixIcon: GestureDetector(
                  child: const Icon(Icons.cancel),
                  onTap: () => Navigator.of(context).pop(), // Close the dialog on tap.
                ),
              ),
              width: double.infinity, // Make dialog width full screen.
            ),

            // Padding around the flag button.
            flagsButtonPadding: const EdgeInsets.all(AppDimensions.small),
            dropdownIconPosition: IconPosition.trailing,
            // Place icon at the end.

            // Style for the dropdown text.
            dropdownTextStyle: GoogleFonts.manrope(
              fontSize: AppDimensions.smallXXL.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.countryCodeColor,
            ),

            // Style for the phone number input text.
            style: GoogleFonts.manrope(
              fontSize: AppDimensions.smallXXL.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.countryCodeColor,
            ),
            disableLengthCheck: true,
            // Disable automatic length check.
            dropdownIcon: Icon(
              Icons.keyboard_arrow_down,
              size: 22.w,
              color: AppColors.countryCodeColor,
            ),

            // Custom decoration for the input field.
            decoration: InputDecoration(
              fillColor: Colors.white,
              // Background color of the input field.
              filled: true,
              // Enable filling background color.
              hintStyle: GoogleFonts.manrope(
                fontSize: AppDimensions.smallXXL.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greye8e8e81,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.small),
                borderSide: const BorderSide(
                  color: AppColors.grey100, // Border color.
                  width: 1.0, // Border width.
                ),
              ),
              border: InputBorder.none,
              // No border.
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.smallXL),
                // Border radius.
                borderSide: const BorderSide(
                  color: AppColors.white, // Border color when focused.
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppDimensions.medium, // Padding inside the input field.
              ),
            ),
            initialValue: widget.countryCode, // Set initial value for country code.
          ),
        ),
        AppDimensions.smallXL.verticalSpace,
        // Add vertical space below the input field.
      ],
    );
  }
}
