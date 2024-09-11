import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';
import '../../../profile/presentation/pages/agent_profile/agent_profile_page_view.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../bloc/home_bloc.dart';
import '../pages/home_page_view.dart';

class HomeTabBarWidget extends StatefulWidget {
  const HomeTabBarWidget({super.key});

  @override
  State<HomeTabBarWidget> createState() => _HomeTabBarWidgetState();
}

class _HomeTabBarWidgetState extends State<HomeTabBarWidget> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomePageView(),
    Center(
      child: HomeKeys.comingSoon.stringToString.titleBold(),
    ),
    Center(
      child: HomeKeys.comingSoon.stringToString.titleBold(),
    ),
    const AgentProfilePageView(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (val, result) {
        AppUtils.showAlertDialog(context, false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<HomeBloc, HomeState>(listener: (context, state) {
          if (state is HomeProfileState) {
            setState(() {
              _currentIndex = 3;
            });
          }
        }, child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return AppBackgroundDecoration(
              child: SafeArea(child: _screens[_currentIndex]));
        })),
        bottomNavigationBar: Container(
          color: AppColors.cancelButtonBgColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabItem(0, HomeKeys.home.stringToString),
              _homeTabItem(1).symmetricPadding(horizontal: 8.sp),
              _buildTabItem(2, HomeKeys.wallet.stringToString),
            ],
          ).singleSidePadding(
            left: AppDimensions.xxlLarge.sp,
            right: AppDimensions.xxlLarge.sp,
            bottom: AppDimensions.small.sp,
          ),
        ),
      ),
    );
  }

  /// Returns the selected icon asset path based on the tab index.
  String getSelectedIcon(int index) {
    switch (index) {
      case 0:
        return Assets.images.homeSelected;
      case 2:
        return Assets.images.walletSelected;
      default:
        return Assets.images.homeSelected;
    }
  }

  /// Returns the unselected icon asset path based on the tab index.
  String getUnSelectedIcon(int index) {
    switch (index) {
      case 0:
        return Assets.images.homeUnselected;
      case 2:
        return Assets.images.walletUnselected;
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor,
            ),
            child: SvgPicture.asset(Assets.images.add)
                .paddingAll(padding: AppDimensions.mediumXL),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            context.read<HomeBloc>().add(const HomeUserDataEvent());
          });
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
              5.verticalSpace,
              _currentIndex == index
                  ? label.titleBold(size: 11.sp, color: AppColors.primaryColor)
                  : label.titleBold(
                      size: 11.sp,
                      color:
                          AppColors.tabsUnselectedTextColor.withOpacity(0.6)),
            ],
          ),
        ));
  }
}
