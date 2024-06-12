import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:xplor/features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../config/services/app_services.dart';
import '../../../../../config/theme/theme_cubit.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/circluar_button.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/mapping_const.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../../presentation/blocs/otp_bloc/otp_bloc.dart';
import '../../../presentation/blocs/phone_bloc/phone_bloc.dart';
import '../../widgets/phone_number_formatter.dart';

/// Widget for the sign-in view.
class PhoneNumberView extends StatefulWidget {
  const PhoneNumberView({super.key, required this.userCheck});

  final bool userCheck;

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

/// State class for the sign-in view.
class _PhoneNumberViewState extends State<PhoneNumberView> {
  bool isValid = false;
  String? countryCode;
  String? countryDialCode;

  final TextEditingController mobileNumberController = TextEditingController();

  @override
  void initState() {
    context.read<PhoneBloc>().add(const PhoneInitialEvent());
    if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedRole) == PrefConstKeys.agentKey) {
      context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
          langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
          moduleTypes: homeModule,
          isNavigation: false));
    }

    context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
        langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
        moduleTypes: walletModule,
        isNavigation: false));
    //context.read<PhoneBloc>().add(const CountryCodeEvent(countryCode: "+91"));
    _getCountryCode();
    super.initState();
  }

  Future<void> _getCountryCode() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark firstPlacemark = placemarks.first;
      setState(() {
        countryCode = firstPlacemark.isoCountryCode;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error Country Code: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme().colors.white,
      body: AppBackgroundDecoration(
        child: SafeArea(
          child: BlocListener<PhoneBloc, PhoneState>(
            listener: (context, state) {
              if (state is SuccessPhoneState) {
                context.read<OtpBloc>().add(PhoneNumberSaveEvent(
                    phoneNumber: state.phoneNumber, key: state.key, countryCode: countryDialCode ?? "+91"));
                Navigator.pushNamed(
                  AppServices.navState.currentContext!,
                  Routes.otp,
                );
              }
            },
            child: BlocBuilder<PhoneBloc, PhoneState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    if (countryCode != null)
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
                                      Assets.images.phoneNumberScreenLogo,
                                    ),
                                  ),
                                  AppDimensions.smallXL.vSpace(),
                                  Center(
                                    child: OnBoardingKeys.welcome.stringToString
                                        .titleExtraBold(size: 32.sp, color: AppColors.countryCodeColor),
                                  ),
                                  AppDimensions.extraSmall.vSpace(),
                                  Center(
                                    child: OnBoardingKeys.beginYourJourney.stringToString
                                        .titleRegular(size: 14.sp, color: AppColors.grey64697a),
                                  ),
                                  AppDimensions.xxl.vSpace(),
                                  AppDimensions.xxl.vSpace(),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0), // Border radius
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
                                        OnBoardingKeys.mobileNumber.stringToString
                                            .titleSemiBold(color: AppColors.blue050505, size: 16.sp),
                                        AppDimensions.smallXL.vSpace(),
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
                                      ],
                                    ).symmetricPadding(horizontal: AppDimensions.medium),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  CircularButton(
                                    isValid: state is PhoneValidState || state is SuccessPhoneState,
                                    title: OnBoardingKeys.sendOtp.stringToString,
                                    onPressed: () {
                                      AppUtils.closeKeyword;
                                      context.read<PhoneBloc>().add(
                                            PhoneSubmitEvent(
                                                phone: mobileNumberController.text.replaceAll(" ", ""),
                                                userCheck: widget.userCheck),
                                          );
                                    },
                                  ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.large),
                                ],
                              )),
                        ],
                      ),
                    if (state is PhoneLoadingState || countryCode == null) const LoadingAnimation(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the title for the suggestion.
  Widget _buildSuggestionTitle() {
    return OnBoardingKeys.otpTopHeaderMessage.stringToString.titleRegular(size: 12.sp, color: AppColors.subTitleText);
  }

  /// Builds the phone number input form field.
  Widget _buildPhoneNumberForm() {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: AppColors.greye8e8e8)),
      child: IntlPhoneField(
        controller: mobileNumberController,
        pickerDialogStyle: PickerDialogStyle(
            countryCodeStyle:
                GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
            countryNameStyle:
                GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.countryCodeColor),
            listTileDivider: const SizedBox(),
            listTilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            padding: const EdgeInsets.all(12),
            searchFieldPadding: const EdgeInsets.only(left: 8, right: 8, top: 20, bottom: 8),
            searchFieldInputDecoration: InputDecoration(
                hintText: '${OnBoardingKeys.searchAnyCountry.stringToString}...',
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
            borderRadius: BorderRadius.circular(12.0), // Border radius
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
}
