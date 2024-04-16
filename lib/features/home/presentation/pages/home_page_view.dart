import 'package:flutter/material.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

import '../../../../utils/app_utils.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context);
      },
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "Welcome".titleBold(),
        ],
      )),
    );
  }
}
