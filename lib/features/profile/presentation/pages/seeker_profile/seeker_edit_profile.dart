import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../../../../utils/widgets/build_button.dart';
import '../../../../../utils/widgets/custom_text_form_fields.dart';
import '../../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../../on_boarding/domain/entities/user_data_entity.dart';

class SeekerEditProfile extends StatefulWidget {
  final UserDataEntity? userData;

  const SeekerEditProfile({super.key, required this.userData});

  @override
  State<SeekerEditProfile> createState() => _SeekerEditProfileState();
}

class _SeekerEditProfileState extends State<SeekerEditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = '${widget.userData?.kyc?.firstName} ${widget.userData?.kyc?.lastName}';
    emailController.text = '${widget.userData?.kyc?.email}';
    addressController.text = address(widget.userData?.kyc?.address);
    dobController.text = '${widget.userData?.kyc?.dob}';
    mobileNumberController.text = '${widget.userData?.phoneNumber}'.replaceAll('${widget.userData?.countryCode}', "");

    String gender = widget.userData?.kyc?.gender == 'NA'
        ? 'NA'
        : widget.userData?.kyc?.gender == "M"
            ? ProfileKeys.male.stringToString
            : ProfileKeys.female.stringToString;
    genderController.text = gender;
    debugPrint('Country Code: ${widget.userData?.countryCode}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Column(
              children: [
                CommonTopHeader(
                  title: ProfileKeys.editProfile.stringToString,
                  isTitleOnly: false,
                  dividerColor: AppColors.checkBoxDisableColor,
                  onBackButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                _bodyView()
              ],
            )),
            SliverFillRemaining(
                child: Column(
              children: [
                const Spacer(),
                ButtonWidget(
                  onPressed: () {},
                  title: ProfileKeys.saveChanges.stringToString,
                  isValid: false,
                ).symmetricPadding(horizontal: AppDimensions.medium),
                const Spacer()
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _bodyView() {
    return Column(
      children: [
        CustomTextFormField(controller: nameController, label: ProfileKeys.name.stringToString, readOnly: true),
        AppDimensions.small.vSpace(),
        widget.userData?.kyc?.email != 'NA'
            ? CustomTextFormField(controller: emailController, label: ProfileKeys.email.stringToString, readOnly: true)
            : Container(),
        widget.userData?.kyc?.gender != 'NA'
            ? CustomTextFormField(
                controller: genderController, label: ProfileKeys.gender.stringToString, readOnly: true)
            : Container(),
        AppDimensions.small.vSpace(),
        _buildPhoneNumberForm(),
        AppDimensions.small.vSpace(),
        widget.userData?.kyc?.dob != ''
            ? CustomTextFormField(
                controller: dobController, label: ProfileKeys.dateOfBirth.stringToString, readOnly: true)
            : Container(),
        CustomTextFormField(
            controller: addressController, label: ProfileKeys.addressString.stringToString, readOnly: true),
      ],
    ).paddingAll(padding: AppDimensions.medium);
  }

  Widget _buildPhoneNumberForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ProfileKeys.mobileNo.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
      AppDimensions.smallXL.vSpace(),
      Container(
        decoration: const BoxDecoration(color: Colors.transparent, boxShadow: [
          BoxShadow(
            color: AppColors.grey100,
            offset: Offset(0, 10),
            blurRadius: 30,
          )
        ]),
        child: IntlPhoneField(
          enabled: false,
          controller: mobileNumberController,
          pickerDialogStyle: PickerDialogStyle(
              backgroundColor: Colors.white,
              countryCodeStyle:
                  GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
              countryNameStyle:
                  GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
              listTileDivider: const SizedBox(),
              listTilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              padding: const EdgeInsets.all(12),
              searchFieldPadding: const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
              searchFieldInputDecoration: InputDecoration(
                  hintStyle: GoogleFonts.manrope(
                      fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
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
          dropdownTextStyle:
              GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
          style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
          disableLengthCheck: true,
          dropdownIcon: Icon(
            Icons.keyboard_arrow_down,
            size: 22.w,
            color: AppColors.countryCodeColor,
          ),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintStyle: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.greye8e8e81),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.small),
              borderSide: const BorderSide(
                color: AppColors.grey100,
                width: 1.0, // Border width
              ),
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0), // Border radius
              borderSide: const BorderSide(color: AppColors.white), // Border color when focused
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: AppDimensions.medium), // Height of the TextFormField
          ),
          //initialCountryCode: widget.userData?.countryCode,
          initialValue: widget.userData?.countryCode,
        ),
      ),
      AppDimensions.smallXL.vSpace(),
    ]);
  }

  String address(String? address) {
    if (address == null) {
      return "";
    }
    Map<String, dynamic> addressMap = json.decode(address);
    // Create a list of address components, filtering out null values
    List addressComponents = [
      addressMap['careOf'] ?? "",
      addressMap['houseNumber'] ?? "",
      addressMap['street'] ?? "",
      addressMap['locality'] ?? "",
      addressMap['district'] ?? "",
      addressMap['state'] ?? "",
      addressMap['pincode'] ?? "",
      addressMap['postOffice'] ?? "",
    ].where((component) => component.isNotEmpty).toList();

    // Join the non-null address components with commas
    final addressString = addressComponents.join(', ');
    return addressString;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    addressController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }
}
