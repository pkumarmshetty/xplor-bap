import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/mapping_const.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../../domain/entities/profile_card_options_entity.dart';
import '../../bloc/agent_profile_bloc/agent_profile_bloc.dart';
import '../../widgets/logout_button_widget.dart';
import '../../../../../utils/widgets/profile_header__widget.dart';
import '../../widgets/profile_option_widget.dart';
import '../../../../../utils/widgets/profile_skill_tile_widget.dart';

class AgentProfilePageView extends StatefulWidget {
  const AgentProfilePageView({super.key});

  @override
  State<AgentProfilePageView> createState() => _AgentProfilePageViewState();
}

class _AgentProfilePageViewState extends State<AgentProfilePageView> {
  List<ProfileCardOptionsEntity> _profileCardOptions = [];

  @override
  void initState() {
    super.initState();
    if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode) != "en") {
      context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
          langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
          moduleTypes: profileModule,
          isNavigation: true));
    } else {
      _profileCardOptions.clear();
      _profileCardOptions = [
        ProfileCardOptionsEntity(
          title: ProfileKeys.editProfile.stringToString,
          subTitle: ProfileKeys.editProfileDesc.stringToString,
          icon: Assets.images.editProfile,
        ),
        ProfileCardOptionsEntity(
          title: ProfileKeys.accountPrivacy.stringToString,
          subTitle: ProfileKeys.accountPrivacyDesc.stringToString,
          icon: Assets.images.accountPrivacy,
        ),
        ProfileCardOptionsEntity(
          title: ProfileKeys.settings.stringToString,
          subTitle: ProfileKeys.settingsDesc2.stringToString,
          icon: Assets.images.profileSetting,
        ),
      ];
    }
    context.read<AgentProfileBloc>().add(const ProfileUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AgentProfileBloc, AgentProfileState>(
            listener: (context, state) {
              if (kDebugMode) {
                print("bloc state... ${state.profileState}");
              }
              if (state.profileState == ProfileState.failure) {
                AppUtils.showSnackBar(context, state.message.toString());
              }
              if (state is ProfileLogoutState) {
                AppUtils.clearSession();
                AppUtils.disposeAllBlocs(context);
                Navigator.pushNamedAndRemoveUntil(context, Routes.main, (routes) => false);
              }
              if (state.profileState == ProfileState.userDataLoaded) {
                context.read<AgentProfileBloc>().add(const ProfileAndTranslationEvent());
              }
            },
          ),
          BlocListener<TranslationBloc, TranslateState>(
            listener: (context, state) {
              if (state is TranslationLoaded && state.isNavigation) {
                _profileCardOptions.clear();
                _profileCardOptions = [
                  ProfileCardOptionsEntity(
                    title: ProfileKeys.editProfile.stringToString,
                    subTitle: ProfileKeys.editProfileDesc.stringToString,
                    icon: Assets.images.editProfile,
                  ),
                  ProfileCardOptionsEntity(
                    title: ProfileKeys.accountPrivacy.stringToString,
                    subTitle: ProfileKeys.accountPrivacyDesc.stringToString,
                    icon: Assets.images.accountPrivacy,
                  ),
                  ProfileCardOptionsEntity(
                    title: ProfileKeys.settings.stringToString,
                    subTitle: ProfileKeys.settingsDesc2.stringToString,
                    icon: Assets.images.profileSetting,
                  ),
                ];
                context.read<AgentProfileBloc>().add(const ProfileAndTranslationEvent(isTranslationDone: true));
              }
            },
          ),
        ],
        child: BlocBuilder<AgentProfileBloc, AgentProfileState>(builder: (context, state) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: (state.profileState == ProfileState.done && state.userData != null)
                        ? Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                ProfileKeys.myProfile.stringToString.titleExtraBold(size: 24.sp),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: AppDimensions.small.sp),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.checkBoxDisableColor,
                                      // Border color
                                      width: 1, // Border width
                                    ),
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(AppDimensions.mediumXL),
                                      right: Radius.circular(AppDimensions.mediumXL),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(Assets.images.coins),
                                      10.hSpace(),
                                      '₹ 0'.titleSemiBold(
                                        size: AppDimensions.smallXXL.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ]).symmetricPadding(
                                  vertical: AppDimensions.mediumXL.sp, horizontal: AppDimensions.medium.sp),
                              const Divider(color: AppColors.checkBoxDisableColor),
                              bodyView(state),
                              AppDimensions.mediumXL.vSpace(),
                            ],
                          )
                        : Container(),
                  )
                ],
              ),
              if (state.profileState == ProfileState.loading || state.profileState == ProfileState.userDataLoaded)
                const LoadingAnimation(),
            ],
          );
        }));
  }

  Widget bodyView(AgentProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeaderWidget(
          name: '${state.userData?.kyc?.firstName} ${state.userData?.kyc?.lastName}',
          role: '${state.userData?.role?.type}',
          imageUrl: state.userData?.profileUrl,
          userData: state.userData,
          editOnProfile: true,
        ),
        AppDimensions.large.vSpace(),
        titlesWidget(state),
        AppDimensions.smallXL.vSpace(),
        const Divider(color: AppColors.checkBoxDisableColor),
        AppDimensions.small.vSpace(),
        if (_profileCardOptions.isNotEmpty)
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return AppDimensions.medium.vSpace();
              },
              itemCount: 3,
              // Number of items in the list
              itemBuilder: (context, index) {
                final item = _profileCardOptions[index];
                return ProfileOptionWidget(
                  item: item,
                  index: index,
                  userData: state.userData,
                );
              }),
        AppDimensions.mediumXXL.vSpace(),
        const LogoutButtonWidget(),
      ],
    ).symmetricPadding(horizontal: AppDimensions.mediumXL, vertical: AppDimensions.mediumXL);
  }

  Widget titlesWidget(AgentProfileState state) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ProfileSkillTileWidget(
                  title: ProfileKeys.skilling.stringToString,
                  icon: Assets.images.skilling,
                  value: '0',
                  backgroundColor: AppColors.lightBlueProfileTiles),
            ),
            AppDimensions.smallXL.hSpace(),
            Expanded(
              child: ProfileSkillTileWidget(
                  title: ProfileKeys.retail.stringToString,
                  icon: Assets.images.retail,
                  value: '${state.userData?.count.retail}',
                  backgroundColor: AppColors.lightPurple),
            ),
          ],
        ),
        AppDimensions.smallXL.vSpace(),
        Row(
          children: [
            Expanded(
              child: ProfileSkillTileWidget(
                  title: ProfileKeys.agriculture.stringToString,
                  icon: Assets.images.agriculture,
                  value: '0',
                  backgroundColor: AppColors.lightOrange),
            ),
            AppDimensions.smallXL.hSpace(),
            Expanded(
              child: ProfileSkillTileWidget(
                  title: ProfileKeys.job.stringToString,
                  icon: Assets.images.job,
                  value: '${state.userData?.count.job}',
                  backgroundColor: AppColors.lightGreen.withOpacity(0.25)),
            ),
          ],
        ),
      ],
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
