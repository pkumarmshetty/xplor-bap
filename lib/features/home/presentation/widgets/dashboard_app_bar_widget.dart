import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/home/presentation/bloc/home_bloc.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/space.dart';
import '../../../../utils/extensions/string_to_string.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';

class DashBoardAppBarWidget extends StatelessWidget {
  const DashBoardAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return SliverAppBar(
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        actions: [
          SvgPicture.asset(Assets.images.notification).symmetricPadding(horizontal: AppDimensions.medium),
          GestureDetector(
            onTap: () => context.read<HomeBloc>().add(const HomeProfileEvent()),
            child: SvgPicture.asset(Assets.images.profileUnselected).symmetricPadding(horizontal: AppDimensions.medium),
          ),
        ],
        leadingWidth: double.infinity,
        leading:
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          AppDimensions.extraSmall.vSpace(),
          HomeKeys.currentLocation.stringToString.titleRegular(color: AppColors.tabsUnselectedTextColor, size: 10.sp),
          AppDimensions.extraExtraSmall.vSpace(),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                'Chandigarh'.titleBold(
                  size: AppDimensions.medium.sp,
                  color: AppColors.cityAppBarColor,
                ),
                AppDimensions.small.hSpace(),
                SvgPicture.asset(Assets.images.downArrow),
              ])
        ]).symmetricPadding(horizontal: AppDimensions.medium),
      );
    });
  }
}
