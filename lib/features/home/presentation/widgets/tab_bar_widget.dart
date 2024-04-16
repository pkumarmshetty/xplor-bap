import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../wallet/presentation/pages/wallet_view.dart';
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
    const WalletView(),
    Center(
      child: 'Graph'.titleBold(),
    ),
    Center(
      child: 'User'.titleBold(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabItem(0, 'Home'),
          _buildTabItem(1, 'Wallet'),
          _buildTabItem(2, 'Graph'),
          _buildTabItem(3, 'Jobs'),
        ],
      ).symmetricPadding(
        horizontal: AppDimensions.mediumXL.sp,
        vertical: AppDimensions.extraSmall.sp,
      ),
    );
  }

  /// Returns the selected icon asset path based on the tab index.
  String getSelectedIcon(int index) {
    switch (index) {
      case 0:
        return Assets.images.homeSelected;
      case 1:
        return Assets.images.walletSelected;
      case 2:
        return Assets.images.graphUnselected;
      case 3:
        return Assets.images.userUnselected;
      default:
        return Assets.images.homeSelected;
    }
  }

  /// Returns the unselected icon asset path based on the tab index.
  String getUnSelectedIcon(int index) {
    switch (index) {
      case 0:
        return Assets.images.homeUnselected;
      case 1:
        return Assets.images.walletUnselected;
      case 2:
        return Assets.images.graphUnselected;
      case 3:
        return Assets.images.userUnselected;
      default:
        return Assets.images.homeUnselected;
    }
  }

  Widget _buildTabItem(int index, String label) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? AppColors.primaryColor
                    : AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
            ),
            AppDimensions.smallXL.h.vSpace(),
            SvgPicture.asset(
              _currentIndex == index
                  ? getSelectedIcon(index)
                  : getUnSelectedIcon(index),
            ),
            AppDimensions.extraSmall.vSpace(),
            _currentIndex == index
                ? label.titleMedium(size: 12.sp, color: AppColors.primaryColor)
                : const Text(''),
          ],
        ));
  }
}
