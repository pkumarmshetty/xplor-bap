import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/home_bloc.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';

/// A custom SliverAppBar for the dashboard with actions and a title.
///
/// This widget includes a location display, notification icon, and profile icon.
/// It reacts to events from the `HomeBloc`.
class DashBoardAppBarWidget extends StatelessWidget {
  const DashBoardAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return SliverAppBar(
          // Setting the surface tint color
          surfaceTintColor: AppColors.white,
          // Background color of the app bar
          backgroundColor: AppColors.white,
          // Disables the automatic leading icon
          automaticallyImplyLeading: false,
          // Adds actions to the app bar
          actions: [
            // Notification icon with padding
            SvgPicture.asset(Assets.images.notification).symmetricPadding(horizontal: AppDimensions.medium),
            // Profile icon with tap event to trigger HomeProfileEvent
            GestureDetector(
              onTap: () => context.read<HomeBloc>().add(const HomeProfileEvent()),
              child:
                  SvgPicture.asset(Assets.images.profileUnselected).symmetricPadding(horizontal: AppDimensions.medium),
            ),
          ],
          // Sets the leading width to take the full available space
          leadingWidth: double.infinity,
          // Leading widget of the app bar
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Adds a small vertical space at the top
              AppDimensions.extraSmall.verticalSpace,
              // Displays the current location text
              HomeKeys.currentLocation.stringToString.titleRegular(
                color: AppColors.tabsUnselectedTextColor,
                size: 10.sp,
              ),
              // Adds extra small vertical space
              AppDimensions.extraExtraSmall.verticalSpace,
              // Row containing the location name and a down arrow icon
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Location name displayed in bold
                  'Chandigarh'.titleBold(
                    size: AppDimensions.medium.sp,
                    color: AppColors.cityAppBarColor,
                  ),
                  // Adds horizontal space between the location name and arrow
                  AppDimensions.small.w.horizontalSpace,
                  // Down arrow icon
                  SvgPicture.asset(Assets.images.downArrow),
                ],
              ),
            ],
          ).symmetricPadding(horizontal: AppDimensions.medium),
        );
      },
    );
  }
}
