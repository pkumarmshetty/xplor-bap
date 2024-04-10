import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../utils/app_dimensions.dart';

/// A widget to display welcome content with a title and subtitle.
class WelcomeContentWidget extends StatelessWidget {
  /// The title to display. If not provided, defaults to 'Welcome to Xplor 👋'.
  final String? title;

  /// The subtitle to display. If not provided, defaults to 'Log in to your account'.
  final String? subTitle;

  /// Constructs a [WelcomeContentWidget] with the given [title] and [subTitle].
  const WelcomeContentWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppDimensions.xxl.vSpace(),

        /// Display the title using [titleBold] extension method.
        (title ?? 'Welcome').titleBold(),

        /// Display the subtitle using [titleMedium] extension method with a size of 16.sp.
        (subTitle ?? 'Log in to your account').titleMedium(size: 16.sp),
      ],
    );
  }
}
