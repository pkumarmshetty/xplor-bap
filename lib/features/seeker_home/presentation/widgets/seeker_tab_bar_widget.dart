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

/// A widget that provides a tab bar for the seeker application,
/// allowing navigation between different sections such as Wallet, Home, and Profile.
class SeekerTabBarWidget extends StatefulWidget {
  const SeekerTabBarWidget({super.key});

  @override
  State<SeekerTabBarWidget> createState() => _SeekerTabBarWidgetState();
}

class _SeekerTabBarWidgetState extends State<SeekerTabBarWidget> {
  /// The current index of the selected tab.
  int? _currentIndex;

  final loginFrom =
      sl<SharedPreferencesHelper>().getString(PrefConstKeys.loginFrom);

  final List<Widget> _screens = [
    const MyWalletTab(),
    const SeekerHomePageView(),
    const SeekerProfilePageView(),
  ];

  @override
  void initState() {
    super.initState();
    // Checks if the user has navigated directly from the splash screen.
    if (sl<SharedPreferencesHelper>()
        .getBoolean(PrefConstKeys.isDirectFromSplash)) {
      sl<SharedPreferencesHelper>()
          .setString(PrefConstKeys.searchCategoryInput, "");
      // Initiates dynamic text translation based on the selected language.
      context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
          langCode: sl<SharedPreferencesHelper>()
              .getString(PrefConstKeys.selectedLanguageCode),
          moduleTypes: onBoardingModule,
          isNavigation: false));
    }
    sl<SharedPreferencesHelper>().setString(PrefConstKeys.savedAddress, "NA");

    // Determines the initial tab based on the `loginFrom` value.
    if (loginFrom == PrefConstKeys.seekerWalletKey) {
      _currentIndex = 0;
      sl<SharedPreferencesHelper>()
          .setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
    } else if (loginFrom == PrefConstKeys.seekerProfileKey) {
      _currentIndex = 2;
      sl<SharedPreferencesHelper>()
          .setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
    } else {
      _currentIndex = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevents the user from navigating back.
      canPop: false,
      onPopInvokedWithResult: (val, result) {
        // Shows an alert dialog when back button is pressed.
        AppUtils.showAlertDialog(context, false);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
            child:
                AppBackgroundDecoration(child: _screens[_currentIndex ?? 1])),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: AppColors.cancelButtonBgColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Builds the Wallet tab.
              _buildTabItem(0, SeekerHomeKeys.wallet.stringToString),
              // Builds the Home tab.
              _homeTabItem(1),
              // Builds the Profile tab.
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

  /// Builds the Home tab with a circular button.
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
              color: _currentIndex == index
                  ? AppColors.primaryColor
                  : AppColors.tabsHomeUnSelectedColor,
            ),
            // Displays the selected home icon with padding.
            child: SvgPicture.asset(Assets.images.homeSelectedSeeker)
                .paddingAll(padding: AppDimensions.mediumXL),
          ),
        ),
      ),
    );
  }

  /// Builds a tab item for the given index and label.
  Widget _buildTabItem(int index, String label) {
    return GestureDetector(
        onTap: () async {
          final bool isLoggedIn = await AppUtils.checkToken();
          if (!isLoggedIn && index == 0) {
            //SSEClient.unsubscribeFromSSE();
            // Navigate to login screen
            sl<SharedPreferencesHelper>().setString(
                PrefConstKeys.loginFrom, PrefConstKeys.seekerWalletKey);
            if (mounted) {
              Navigator.pushNamed(context, Routes.login);
            }
          } else if (!isLoggedIn && index == 2) {
            sl<SharedPreferencesHelper>().setString(
                PrefConstKeys.loginFrom, PrefConstKeys.seekerProfileKey);
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
                _currentIndex == index
                    ? getSelectedIcon(index)
                    : getUnSelectedIcon(index),
              ),
              AppDimensions.extraExtraSmall.verticalSpace,
              _currentIndex == index
                  ? label.titleBold(
                      size: AppDimensions.smallXL.sp,
                      color: AppColors.primaryColor)
                  : label.titleBold(
                      size: AppDimensions.smallXL.sp,
                      color:
                          AppColors.tabsUnselectedTextColor.withOpacity(0.58)),
            ],
          ),
        ));
  }
}
