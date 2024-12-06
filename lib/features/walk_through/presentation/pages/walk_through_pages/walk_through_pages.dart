import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../on_boarding/presentation/blocs/select_role_bloc/select_role_bloc.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/utils.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../../../../utils/widgets/build_button.dart';
import '../../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import '../../../../on_boarding/presentation/blocs/select_role_bloc/select_role_event.dart';
import '../../../data/models/walk_through_model.dart';

part 'walk_through_pages_widget.dart';

class WalkThroughPages extends StatefulWidget {
  const WalkThroughPages({super.key});

  @override
  State<WalkThroughPages> createState() => _WalkThroughPagesState();
}

class _WalkThroughPagesState extends State<WalkThroughPages> {
  PageController controller = PageController();
  static dynamic currentPageValue = 0.0;

  List<WalkThroughModel> walkThroughModel = [];

  bool isPopAlready = false;

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
        subTitle: OnBoardingKeys.titleDesStep1.stringToString
    ));
    walkThroughModel.add(WalkThroughModel(
        image: Assets.images.infoSecond,
        title: OnBoardingKeys.titleStep2.stringToString,
        subTitle: OnBoardingKeys.titleDesStep2.stringToString));
    walkThroughModel.add(WalkThroughModel(
        image: Assets.images.infoThird,
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
    return PopScope(
      canPop: false, // Set canPop based on condition
      onPopInvokedWithResult: (val, result) async {
        handleBackFunctionality();
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
      child: backButtonWidget(),
    );
  }

  _bodySliderPageView(BuildContext context) {
    return PageView.builder(
        itemCount: walkThroughModel.length,
        scrollDirection: Axis.horizontal,
        controller: controller,
        itemBuilder: (context, position) {
          return sliderViewItemsWidget(
              walkThroughModel[position],
              context,
              position,
              ButtonWidget(
                customText: Row(
                  children: [
                    position == 2
                        ? AppDimensions.extraSmall.w.horizontalSpace
                        : AppDimensions.mediumXL.w.horizontalSpace,
                    (position == 2
                            ? OnBoardingKeys.getStarted.stringToString
                            : OnBoardingKeys.next.stringToString)
                        .buttonTextBold(size: 14.sp, color: Colors.white),
                    position == 2
                        ? AppDimensions.medium.w.horizontalSpace
                        : AppDimensions.xxl.w.horizontalSpace,
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: AppColors.white,
                      size: AppDimensions.medium,
                    ),
                  ],
                ),
                isValid: true,
                onPressed: () {
                  if (position == 2) {
                    if (sl<SharedPreferencesHelper>()
                        .getBoolean(PrefConstKeys.appForBelem)) {
                      Navigator.pushNamed(context, Routes.seekerHome);
                    } else {
                      Navigator.pushNamed(context, Routes.seekerHome);
                    }
                  } else {
                    controller.nextPage(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.decelerate);
                  }
                },
              ));
          /* return Transform(
          transform: Matrix4.identity()..rotateX(currentPageValue - position),
          child:
              sliderViewItems(walkThroughModel[position], context, position),
        );*/
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleBackFunctionality() {
    if (currentPageValue == 0.0 && !isPopAlready) {
      isPopAlready = true;
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
