import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';
import '../bloc/home_bloc.dart';
import '../../../../utils/utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context, false);
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return Stack(children: [
          if (state is HomeUserDataState)
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: AppColors.white,
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        'Current location'.titleRegular(size: 12.sp),
                        2.vSpace(),
                        Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.asset(Assets.images.location),
                          10.hSpace(),
                          'Delhi'.titleBold(
                            size: 16.sp,
                            color: AppColors.primaryColor,
                          ),
                        ])
                      ]).singleSidePadding(left: 5),
                  actions: [
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(Assets.images.notification),
                    ).singleSidePadding(right: AppDimensions.mediumXL),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppDimensions.mediumXL.vSpace(),
                      'Hi, ${state.userData.kyc.firstName}!'.titleBold(size: 24.sp),
                    ],
                  ).symmetricPadding(horizontal: AppDimensions.mediumXL),
                ),
                SliverFillRemaining(
                  child: Center(
                      child: '${state.userData.role.type} dashboard is\ncoming soon...'
                          .capitalizeFirstLetter()
                          .titleRegular(align: TextAlign.center)),
                )
              ],
            ),
          if (state is HomeUserDataLoadingState) const LoadingAnimation(),
        ]);
      }),
    );
  }
}
