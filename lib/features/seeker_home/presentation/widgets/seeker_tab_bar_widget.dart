import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../../profile/presentation/pages/seeker_profile/seeker_profile_page_view.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../pages/seeker_home_page_view.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/mapping_const.dart';
import '../../../../utils/utils.dart';
import '../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../../wallet/presentation/pages/wallet_tab_view.dart';

class SeekerTabBarWidget extends StatefulWidget {
  const SeekerTabBarWidget({super.key});

  @override
  State<SeekerTabBarWidget> createState() => _SeekerTabBarWidgetState();
}

class _SeekerTabBarWidgetState extends State<SeekerTabBarWidget> {
  int? _currentIndex;

  final loginFrom = sl<SharedPreferencesHelper>().getString(PrefConstKeys.loginFrom);

  final List<Widget> _screens = [
    const MyWalletTab(),
    const SeekerHomePageView(),
    const SeekerProfilePageView(),
  ];

  @override
  void initState() {
    super.initState();
    if (sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.isDirectFromSplash)) {
      sl<SharedPreferencesHelper>().setString(PrefConstKeys.searchCategoryInput, "");
      context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
          langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
          moduleTypes: onBoardingModule,
          isNavigation: false));
    }
    if (loginFrom == PrefConstKeys.seekerWalletKey) {
      _currentIndex = 0;
      sl<SharedPreferencesHelper>().setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
    } else if (loginFrom == PrefConstKeys.seekerProfileKey) {
      _currentIndex = 2;
      sl<SharedPreferencesHelper>().setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
    } else {
      _currentIndex = 1;
    }

    /*context.read<TranslationBloc>().add(const TranslateDynamicTextEvent(langCode: 'en', moduleTypes: seekerHomeModule));

    context.read<TranslationBloc>().add(const TranslateDynamicTextEvent(langCode: 'en', moduleTypes: walletModule));

    context.read<TranslationBloc>().add(const TranslateDynamicTextEvent(langCode: 'en', moduleTypes: profileModule));

    context.read<TranslationBloc>().add(const TranslateDynamicTextEvent(langCode: 'en', moduleTypes: mPinModule));*/
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context, false);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(child: AppBackgroundDecoration(child: _screens[_currentIndex ?? 1])),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: AppColors.cancelButtonBgColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabItem(0, SeekerHomeKeys.wallet.stringToString),
              _homeTabItem(1),
              _buildTabItem(2, SeekerHomeKeys.profile.stringToString),
            ],
          ).singleSidePadding(
            left: AppDimensions.xxlLarge.sp,
            right: AppDimensions.xxlLarge.sp,
            bottom: AppDimensions.smallXL.sp,
          ),
        ),
      ),
    );
  }

  /// Returns the selected icon asset path based on the tab index.
  String getSelectedIcon(int index) {
    switch (index) {
      case 0:
        return Assets.images.walletSelected;
      case 1:
        return Assets.images.homeSelected;
      case 2:
        return Assets.images.profileSelected;
      default:
        return Assets.images.homeSelected;
    }
  }

  /// Returns the unselected icon asset path based on the tab index.
  String getUnSelectedIcon(int index) {
    switch (index) {
      case 0:
        return Assets.images.walletUnselected;
      case 1:
        return Assets.images.homeUnselected;
      case 2:
        return Assets.images.profileUnselected;
      default:
        return Assets.images.homeUnselected;
    }
  }

  Widget _homeTabItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        height: 83.sp,
        width: 83.sp,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        child: Center(
          child: Container(
            width: 60.sp,
            height: 60.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? AppColors.primaryColor : AppColors.tabsHomeUnSelectedColor,
            ),
            child: SvgPicture.asset(Assets.images.homeSelectedSeeker).paddingAll(padding: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    return GestureDetector(
        onTap: () async {
          final bool isLoggedIn = await AppUtils.checkToken();
          if (!isLoggedIn && index == 0) {
            //SSEClient.unsubscribeFromSSE();
            // Navigate to login screen
            sl<SharedPreferencesHelper>().setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerWalletKey);
            if (mounted) {
              Navigator.pushNamed(context, Routes.login);
            }
          } else if (!isLoggedIn && index == 2) {
            sl<SharedPreferencesHelper>().setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerProfileKey);
            if (mounted) {
              Navigator.pushNamed(context, Routes.login);
            }
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                _currentIndex == index ? getSelectedIcon(index) : getUnSelectedIcon(index),
              ),
              AppDimensions.extraExtraSmall.vSpace(),
              _currentIndex == index
                  ? label.titleBold(size: AppDimensions.smallXL.sp, color: AppColors.primaryColor)
                  : label.titleBold(
                      size: AppDimensions.smallXL.sp, color: AppColors.tabsUnselectedTextColor.withOpacity(0.58)),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    // SSEClient.unsubscribeFromSSE();
  }
}
