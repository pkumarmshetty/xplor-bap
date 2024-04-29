import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/profile/presentation/widgets/common_profile_title_value_widget.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../wallet/presentation/widgets/wallet_common_widget.dart';
import '../bloc/profile_bloc.dart';

class ProfileTabView extends StatefulWidget {
  const ProfileTabView({super.key});

  @override
  State<ProfileTabView> createState() => _ProfileTabViewState();
}

class _ProfileTabViewState extends State<ProfileTabView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const ProfileUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {},
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              // Handle state changes
              if (state is ProfileUserDataLoadingState) {
                // Show loading animation
                return const LoadingAnimation();
              } else {
                if (state is ProfileUserDataState) {
                  // Show main content
                  var firstName = state.userData.kyc.firstName == 'NA' ? '' : state.userData.kyc.firstName;
                  var lastName = state.userData.kyc.lastName == 'NA' ? '' : state.userData.kyc.lastName;

                  return ListView(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.vSpace(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.edit_note,
                          size: 40.w,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              SvgPicture.asset(
                                Assets.images.icAvtar,
                                height: 100,
                                width: 100,
                              ),
                              SvgPicture.asset(
                                Assets.images.icEdit,
                              )
                            ],
                          ),
                          AppDimensions.medium.vSpace(),
                          '$firstName $lastName'.titleExtraBold(size: 24.sp, color: AppColors.countryCodeColor),
                          AppDimensions.extraSmall.vSpace(),
                          state.userData.role.type
                              .capitalizeFirstLetter()
                              .titleRegular(size: 16.sp, color: AppColors.grey9898a5),
                        ],
                      ),
                      40.vSpace(),
                      'Basic Info'.titleExtraBold(size: 20.sp, color: AppColors.countryCodeColor),
                      AppDimensions.medium.vSpace(),
                      CommonProfileTitleValueWidget(
                          icon: Assets.images.icEmail,
                          title: 'Email:',
                          value: state.userData.kyc.email!,
                          isDivider: true),
                      AppDimensions.small.vSpace(),
                      CommonProfileTitleValueWidget(
                          icon: Assets.images.icPhone,
                          title: 'Mobile No:',
                          value: state.userData.phoneNumber!,
                          isDivider: true),
                      AppDimensions.small.vSpace(),
                      CommonProfileTitleValueWidget(
                          icon: Assets.images.icGender,
                          title: 'Gender:',
                          value: state.userData.kyc.gender == "NA"
                              ? "NA"
                              : state.userData.kyc.gender == "M"
                                  ? "Male"
                                  : "Female",
                          isDivider: true),
                      if (state.userData.kyc.dob!.isNotEmpty) AppDimensions.small.vSpace(),
                      if (state.userData.kyc.dob!.isNotEmpty)
                        CommonProfileTitleValueWidget(
                            icon: Assets.images.icDob,
                            title: 'DOB:',
                            value: AppUtils.convertDateFormatToAnother(
                                'dd/MM/yyyy', 'dd MMMM, yyyy', state.userData.kyc.dob!),
                            isDivider: true),
                      AppDimensions.small.vSpace(),
                      CommonProfileTitleValueWidget(
                          icon: Assets.images.icLocation,
                          title: 'Address',
                          value: address(state.userData.kyc.address),
                          isDivider: false),
                      AppDimensions.large.vSpace(),
                      RevokeButtonWidget(
                        icon: Assets.images.icLogout,
                        radius: 8,
                        text: 'Logout',
                        backgroundColor: AppColors.redd92727,
                        onPressed: () {
                          AppUtils.clearSession(context);
                        },
                      )
                    ],
                  ).symmetricPadding(horizontal: AppDimensions.mediumXL);
                } else {
                  return const SizedBox();
                }
              }
            },
          ),
        ),
      ),
    );
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
}
