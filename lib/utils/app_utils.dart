import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

import '../config/services/app_services.dart';
import 'app_dimensions.dart';

class AppUtils {
  static get closeKeyword {
    FocusScope.of(AppServices.navState.currentContext!).unfocus();
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.errorColor,
      padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.mediumXL, horizontal: AppDimensions.medium),
      content: (message.contains("Exception:")
              ? message.replaceAll("Exception:", "")
              : message)
          .titleBold(size: 14.sp, color: AppColors.white),
    ));
  }

  static String getErrorMessage(String message) {
    return message.contains("Exception: ")
        ? message.replaceAll("Exception: ", "")
        : message;
  }
}
