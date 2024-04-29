import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:xplor/features/wallet/presentation/widgets/enter_mpin_dialog.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

import '../../config/routes/path_routing.dart';
import '../../config/services/app_services.dart';

import '../../const/local_storage/shared_preferences_helper.dart';
import '../../const/user_define_function.dart';
import '../../core/dependency_injection.dart';
import '../../gen/assets.gen.dart';
import '../app_dimensions.dart';
import '../widgets/build_button.dart';
import '../widgets/top_header_for_dialogs.dart';

part 'app_utils_dialogs.dart';
part 'app_utils_media.dart';

class AppUtils with AppUtilsDialogMixin, AppUtilsMediaMixin {
  static get closeKeyword {
    FocusScope.of(AppServices.navState.currentContext!).unfocus();
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: AppColors.errorColor,
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.mediumXL, horizontal: AppDimensions.medium),
      content: (message.contains("Exception:") ? message.replaceAll("Exception:", "") : message)
          .titleBold(size: 14.sp, color: AppColors.white),
    ));
  }

  static String getErrorMessage(String message) {
    return message.contains("Exception: ") ? message.replaceAll("Exception: ", "") : message;
  }

  static void showAlertDialog(BuildContext context, bool isTokenClear) {
    AppUtilsDialogMixin.showAlertDialog(context, isTokenClear);
  }

  static void showAlertDialogForConfirmation(
    BuildContext context,
    String title,
    String message,
    String leftButtonMessage,
    String rightButtonMessage, {
    required VoidCallback onConfirm,
  }) {
    AppUtilsDialogMixin.showAlertDialogForConfirmation(
        context, title, message, leftButtonMessage, rightButtonMessage, false, onConfirm);
  }

  static Future<bool> checkToken() {
    SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

    // Initialize SharedPreferencesHelper and wait for initialization
    return initializeSharedPreferencesHelper(preferencesHelper);
  }

  static Future<bool> initializeSharedPreferencesHelper(SharedPreferencesHelper preferencesHelper) async {
    // Initialize SharedPreferencesHelper and wait for initialization
    await preferencesHelper.init();

    // Use SharedPreferencesHelper to get the token
    var authToken = preferencesHelper.getString(PrefConstKeys.token);
    var isHomeOpen = preferencesHelper.getBoolean(PrefConstKeys.isHomeOpen);

    // Return true if authToken is not null
    return authToken != 'NA' && authToken != '' && isHomeOpen;
  }

  static void chooseFileDialog({required GetMediaData getMediaData}) {
    AppUtilsMediaMixin.chooseFileDialog(getMediaData: getMediaData);
  }

  static void shareFile(String text) {
    var sharedId = "Test share";
    sharedId = sl<SharedPreferencesHelper>().getString(PrefConstKeys.sharedId);
    if (kDebugMode) {
      print("sharedId....$sharedId");
    }

    if (Platform.isAndroid) {
      Share.share(sharedId);
    } else if (Platform.isIOS) {
      //exit(0);
    }
  }

  static String convertDateFormat(String dateString) {
    final parsedDate = DateTime.parse(dateString).toLocal();
    final formatter = DateFormat('dd MMMM, yyyy hh:mm:ss');
    final formattedDate = formatter.format(parsedDate);
    return formattedDate;
  }

  static String convertDateFormatToAnother(String inputDateFormat, String outputDateFormat, String input) {
    try {
      if (input == 'NA') {
        return '';
      }
      // Parse the input string to DateTime
      DateFormat inputFormat = DateFormat(inputDateFormat);
      DateTime dateTime = inputFormat.parse(input);

      DateFormat outputFormat = DateFormat(outputDateFormat);
      String formattedDate = outputFormat.format(dateTime);

      if (kDebugMode) {
        print(formattedDate);
      } // Output: 24 November, 2000

      return formattedDate;
    } catch (e) {
      return "Format issue";
    }
  }

  static String convertValidityToDays(int dateString) {
    double result = dateString / 24;
    String formattedResult = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
    return '$formattedResult Days';
  }

  static String add8HoursAndConvertToDateFormat(String date, int hours) {
    // Parse the input date string
    DateTime inputDate = DateTime.parse(date);

    // Add 10 hours
    DateTime resultDate = inputDate.add(const Duration(hours: 10));

    // Format the result date
    String formattedResult = resultDate.toIso8601String();
    return convertDateFormat(formattedResult);
  }

  static int getHoursAccordingToDaySelection(int selectedRadioIndex) {
    var days = 7;
    switch (selectedRadioIndex) {
      case 1:
        {
          days = 7;
        }
      case 2:
        {
          days = 1;
        }
      case 3:
        {
          days = 3;
        }
      case 4:
        {
          days = 7;
        }
    }
    return days * 24;
  }

  static clearSession(BuildContext context) {
    sl<SharedPreferencesHelper>().setString(PrefConstKeys.token, "");
    sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isHomeOpen, false);
    Navigator.pushNamedAndRemoveUntil(context, Routes.main, (routes) => false);
  }

  static loadThumbnailBasedOnMimeTime(String? mimeType) {
    if (mimeType == null || mimeType == 'application/pdf') {
      return Assets.images.icDocument;
    } else if (mimeType == 'image/png') {
      return Assets.images.icImagePngIcon;
    } else {
      return Assets.images.icImageJpgIcon;
    }
  }
}
