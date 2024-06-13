import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/select_role_bloc/select_role_bloc.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import '../../../on_boarding/presentation/blocs/select_role_bloc/select_role_event.dart';
import '../../data/models/walk_through_model.dart';

class WalkThroughPages extends StatefulWidget {
  const WalkThroughPages({super.key});

  @override
  State<WalkThroughPages> createState() => _WalkThroughPagesState();
}

class _WalkThroughPagesState extends State<WalkThroughPages> {
  PageController controller = PageController();
  static dynamic currentPageValue = 0.0;

  List<WalkThroughModel> walkThroughModel = [];

  @override
  void initState() {
    super.initState();

    if (sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.appForBelem)) {
      context.read<SelectRoleBloc>().add(const SaveRoleOnServerForBelem());
    }

    walkThroughModel.clear();
    walkThroughModel.add(WalkThroughModel(
        image: Assets.images.infoFirst,
        title: OnBoardingKeys.titleStep1.stringToString,
        subTitle: OnBoardingKeys.titleDesStep1.stringToString));
    walkThroughModel.add(WalkThroughModel(
        image: Assets.images.infoSecond,
        title: OnBoardingKeys.titleStep2.stringToString,
        subTitle: OnBoardingKeys.titleDesStep2.stringToString));
    walkThroughModel.add(WalkThroughModel(
        image: Assets.images.infoFirst,
        title: OnBoardingKeys.titleStep3.stringToString,
        subTitle: OnBoardingKeys.titleDesStep3.stringToString));
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue == 0) {
          return true; // Allow popping the screen
        } else {
          controller.previousPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.decelerate,
          );
          return false; // Prevent popping the screen
        }
      },
      child: Scaffold(
          body: AppBackgroundDecoration(
              child: SafeArea(
                  child: Stack(
        children: [
          _bodySliderPageView(context),
          _appBarView(),
        ],
      )))),
    );
  }

  _appBarView() {
    return GestureDetector(
      onTap: () {
        handleBackFunctionality();
      },
      child: Container(
        height: 38.w,
        width: 38.w,
        margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.medium, vertical: AppDimensions.mediumXL),
        decoration: BoxDecoration(
          color: AppColors.blueWith10Opacity,
          // Set your desired background color
          borderRadius:
              BorderRadius.circular(10), // Set your desired border radius
        ),
        child: SvgPicture.asset(height: 16.w, width: 16.w, Assets.images.icBack)
            .paddingAll(padding: AppDimensions.smallXL),
      ),
    );
  }

  _bodySliderPageView(BuildContext context) {
    return PageView.builder(
        itemCount: walkThroughModel.length,
        scrollDirection: Axis.horizontal,
        controller: controller,
        itemBuilder: (context, position) {
          return sliderViewItems(walkThroughModel[position], context, position);
          /* return Transform(
          transform: Matrix4.identity()..rotateX(currentPageValue - position),
          child:
              sliderViewItems(walkThroughModel[position], context, position),
        );*/
        });
  }

  sliderViewItems(WalkThroughModel model, BuildContext context, int pos) {
    return Stack(
      children: [
        SvgPicture.asset(
          model.image,
          width: MediaQuery.of(context).size.width, // Set the width of the SVG
        ).symmetricPadding(vertical: AppDimensions.xxl),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Container()),
            model.title.titleBlack().fadeAnimation(),
            AppDimensions.extraSmall.vSpace(),
            model.subTitle
                .titleBold(color: AppColors.grey64697a, size: 14.sp)
                .fadeAnimation(),
            AppDimensions.smallXL.vSpace(),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: List.generate(
                  3,
                  (index) => Container(
                        height: AppDimensions.small,
                        width: AppDimensions.small,
                        margin: const EdgeInsets.only(
                            right: AppDimensions.extraSmall),
                        decoration: BoxDecoration(
                            color: pos == index
                                ? AppColors.primaryColor
                                : AppColors.grey200,
                            shape: BoxShape.circle),
                      )),
            ),
            50.w.vSpace(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pos != 2)
                  GestureDetector(
                    onTap: () {
                      if (sl<SharedPreferencesHelper>()
                          .getBoolean(PrefConstKeys.appForBelem)) {
                        Navigator.pushNamed(context, Routes.chooseDomain);
                      } else {
                        Navigator.pushNamed(context, Routes.chooseRole);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          right: AppDimensions.medium,
                          top: AppDimensions.medium,
                          bottom: AppDimensions.medium),
                      color: Colors.transparent,
                      child: OnBoardingKeys.skip.stringToString.titleMedium(
                          color: AppColors.grey64697a, size: 14.sp),
                    ),
                  ),
                const Spacer(),
                ButtonWidget(
                  customText: Row(
                    children: [
                      pos == 2
                          ? AppDimensions.extraSmall.hSpace()
                          : AppDimensions.mediumXL.hSpace(),
                      (pos == 2
                              ? OnBoardingKeys.getStarted.stringToString
                              : OnBoardingKeys.next.stringToString)
                          .buttonTextBold(size: 14.sp, color: Colors.white),
                      pos == 2
                          ? AppDimensions.medium.hSpace()
                          : AppDimensions.xxl.hSpace(),
                      const Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: AppColors.white,
                        size: AppDimensions.medium,
                      ),
                    ],
                  ),
                  isValid: true,
                  onPressed: () {
                    if (pos == 2) {
                      if (sl<SharedPreferencesHelper>()
                          .getBoolean(PrefConstKeys.appForBelem)) {
                        Navigator.pushNamed(context, Routes.chooseDomain);
                      } else {
                        Navigator.pushNamed(context, Routes.chooseRole);
                      }
                    } else {
                      controller.nextPage(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.decelerate);
                    }
                  },
                ),
              ],
            ),
            AppDimensions.small.w.vSpace(),
            Center(
              child: 'Powered by Xplor-Beckn'
                  .titleSemiBold(
                      color: AppColors.primaryLightColor, size: 14.sp)
                  .singleSidePadding(top: AppDimensions.small)
                  .fadeInAnimated(),
            ),
          ],
        ).symmetricPadding(
            horizontal: AppDimensions.medium, vertical: AppDimensions.large),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleBackFunctionality() {
    if (currentPageValue == 0.0) {
      Navigator.of(context).pop();
    } else {
      // If condition is not met, perform navigation after the frame is completed
      controller.previousPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.decelerate,
      );
    }
  }
}
