import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/profile/presentation/bloc/seeker_profile_bloc/seeker_profile_bloc.dart';
import 'package:xplor/utils/mapping_const.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../widgets/logout_button_widget.dart';
import '../../widgets/profile_option_widget.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/space.dart';
import '../../../../../utils/extensions/string_to_string.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../domain/entities/profile_card_options_entity.dart';
import '../../../../../utils/widgets/profile_header__widget.dart';
import '../../../../../utils/widgets/profile_skill_tile_widget.dart';

class SeekerProfilePageView extends StatefulWidget {
  const SeekerProfilePageView({super.key});

  @override
  State<SeekerProfilePageView> createState() => _SeekerProfilePageViewState();
}

class _SeekerProfilePageViewState extends State<SeekerProfilePageView> {
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
          title: ProfileKeys.myAccount.stringToString,
          subTitle: ProfileKeys.editProfile.stringToString,
          icon: Assets.images.editProfile,
        ),
        ProfileCardOptionsEntity(
          title: ProfileKeys.accountPrivacy.stringToString,
          subTitle: ProfileKeys.accountPrivacyDesc.stringToString,
          icon: Assets.images.accountPrivacy,
        ),
        ProfileCardOptionsEntity(
          title: ProfileKeys.settings.stringToString,
          subTitle: ProfileKeys.settingsDesc.stringToString,
          icon: Assets.images.profileSetting,
        ),
      ];
    }
    context.read<SeekerProfileBloc>().add(const ProfileUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("inside build");
    }
    return MultiBlocListener(
        listeners: [
          BlocListener<SeekerProfileBloc, SeekerProfileState>(
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
                context.read<SeekerProfileBloc>().add(const ProfileAndTranslationEvent());
              }
            },
          ),
          BlocListener<TranslationBloc, TranslateState>(
            listener: (context, state) {
              if (state is TranslationLoaded && state.isNavigation) {
                _profileCardOptions.clear();
                _profileCardOptions = [
                  ProfileCardOptionsEntity(
                    title: ProfileKeys.myAccount.stringToString,
                    subTitle: ProfileKeys.editProfile.stringToString,
                    icon: Assets.images.editProfile,
                  ),
                  ProfileCardOptionsEntity(
                    title: ProfileKeys.accountPrivacy.stringToString,
                    subTitle: ProfileKeys.accountPrivacyDesc.stringToString,
                    icon: Assets.images.accountPrivacy,
                  ),
                  ProfileCardOptionsEntity(
                    title: ProfileKeys.settings.stringToString,
                    subTitle: ProfileKeys.settingsDesc.stringToString,
                    icon: Assets.images.profileSetting,
                  ),
                ];
                context.read<SeekerProfileBloc>().add(const ProfileAndTranslationEvent(isTranslationDone: true));
              }
            },
          ),
        ],
        child: BlocBuilder<SeekerProfileBloc, SeekerProfileState>(builder: (context, state) {
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: (state.profileState == ProfileState.done && state.userData != null)
                        ? Column(
                            children: [
                              CommonTopHeader(
                                title: ProfileKeys.myProfile.stringToString,
                                isTitleOnly: true,
                                dividerColor: AppColors.checkBoxDisableColor,
                                onBackButtonPressed: () {},
                              ),
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

  Widget bodyView(SeekerProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeaderWidget(
          name: '${state.userData?.kyc?.firstName} ${state.userData?.kyc?.lastName}',
          role: '${state.userData?.role?.type}',
          imageUrl: state.userData?.profileUrl,
          userData: state.userData,
          editOnProfile: false,
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
                return ProfileOptionWidget(item: item, index: index, userData: state.userData);
              }),
        AppDimensions.medium.vSpace(),
        const LogoutButtonWidget(),
      ],
    ).symmetricPadding(horizontal: AppDimensions.mediumXL, vertical: AppDimensions.mediumXL);
  }

  Widget titlesWidget(SeekerProfileState state) {
    return Row(
      children: [
        Expanded(
          child: ProfileSkillTileWidget(
            title: ProfileKeys.myJob.stringToString,
            icon: Assets.images.job,
            value: '${state.userData?.count.job}',
            backgroundColor: AppColors.lightGreen.withOpacity(0.25),
          ),
        ),
        AppDimensions.smallXL.hSpace(),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.myOrders),
            child: ProfileSkillTileWidget(
              title: ProfileKeys.orders.stringToString,
              icon: Assets.images.skilling,
              value: '${state.userData?.count.orders}',
              backgroundColor: AppColors.lightBlueProfileTiles,
            ),
          ),
        ),
      ],
    );
  }
}
