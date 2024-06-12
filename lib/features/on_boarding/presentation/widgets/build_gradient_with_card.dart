import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/padding.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_gradient.dart';
import '../../../../utils/widgets/loading_animation.dart';

Widget buildScreenContent(Widget contentWidget, Widget bottomWidget, BuildContext context, bool isLoader) {
  return Container(
    decoration: const BoxDecoration(
      gradient: AppGradients.screenBackgroundGradient,
    ),
    child: SafeArea(
      child: Stack(
        children: [
          // Column for Layout
          Column(
            children: [
              // Space for App Icon - 1/3 of screen height
              Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  Assets.images.appLogo, // Your icon here
                  height: 72.w,
                  width: 72.w,
                ),
              ),

              // Rounded Corner Card - 2/3 of screen height
              Expanded(
                flex: 2,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(child: contentWidget),
                        SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              children: [
                                const Spacer(),
                                bottomWidget.paddingAll(padding: AppDimensions.medium),
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
          if (isLoader) const LoadingAnimation(),
        ],
      ),
    ),
  );
}
