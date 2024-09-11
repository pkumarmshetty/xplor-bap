import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';

/// A widget to display welcome content with a title and subtitle.
class WelcomeContentWidget extends StatelessWidget {
  /// The title to display. If not provided, defaults to 'Welcome to Xplor 👋'.
  final String? title;

  final Color? color;

  /// The subtitle to display. If not provided, defaults to 'Log in to your account'.
  final String? subTitle;

  /// Constructs a [WelcomeContentWidget] with the given [title] and [subTitle].
  const WelcomeContentWidget({super.key, this.title, this.color, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AppDimensions.smallXL.verticalSpace,

        /// Display the title using [titleBold] extension method.
        (title ?? OnBoardingKeys.welcome.stringToString).titleExtraBold(color: color ?? AppColors.countryCodeColor),

        /// Display the subtitle using [titleMedium] extension method with a size of 16.sp.
        (subTitle ?? OnBoardingKeys.beginYourJourney.stringToString)
            .titleRegular(size: 14.sp, color: color ?? AppColors.countryCodeColor),
      ],
    );
  }
}
