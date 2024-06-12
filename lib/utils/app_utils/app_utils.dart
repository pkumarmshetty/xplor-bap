import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:xplor/core/exception_errors.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/features/wallet/presentation/widgets/enter_mpin_dialog.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import '../../config/services/app_services.dart';

import '../../const/local_storage/shared_preferences_helper.dart';
import '../../const/user_define_function.dart';
import '../../core/dependency_injection.dart';
import '../../features/multi_lang/domain/mappers/app_utils/app_utils_keys.dart';
import '../../features/multi_lang/domain/mappers/mpin/generate_mpin_keys.dart';
import '../../features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import '../../features/multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../features/on_boarding/presentation/blocs/choose_domain/choose_domain_bloc.dart';
import '../../features/on_boarding/presentation/blocs/select_category/categories_bloc.dart';
import '../../features/profile/presentation/bloc/agent_profile_bloc/agent_profile_bloc.dart';
import '../../features/profile/presentation/bloc/seeker_profile_bloc/seeker_profile_bloc.dart';
import '../../features/seeker_home/presentation/blocs/seeker_dashboard_bloc/seeker_home_bloc.dart';
import '../../gen/assets.gen.dart';
import '../app_dimensions.dart';
import '../circluar_button.dart';
import '../widgets/blur_widget.dart';
import '../widgets/build_button.dart';
import '../widgets/top_header_for_dialogs.dart';

part 'app_utils_dialogs.dart';

part 'app_utils_media.dart';

class AppUtils with AppUtilsDialogMixin, AppUtilsMediaMixin {
  static get closeKeyword {
    FocusScope.of(AppServices.navState.currentContext!).unfocus();
  }

  static void showSnackBar(BuildContext context, String message,
      {Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: bgColor ?? AppColors.errorColor,
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
    AppUtilsDialogMixin.showAlertDialogForConfirmation(context, title, message,
        leftButtonMessage, rightButtonMessage, false, onConfirm);
  }

  static void linkGeneratedDialog(
    BuildContext context,
    String title,
    String message,
    String buttonText, {
    required VoidCallback onConfirm,
  }) {
    AppUtilsDialogMixin.linkGeneratedDialog(
        context, title, message, buttonText, onConfirm);
  }

  static void showAlertDialogForRevokeAccess(
      BuildContext context,
      String title,
      String message,
      String leftButtonMessage,
      String rightButtonMessage,
      bool isCrossIconVisible,
      VoidCallback onConfirm) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.medium),
            ),
            backgroundColor: AppColors.white,
            elevation: 0,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopHeaderForDialogs(
                    title: title, isCrossIconVisible: isCrossIconVisible),

                /// Message with custom styling
                message
                    .titleSemiBold(size: 16.sp)
                    .symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the message
                AppDimensions.large.vSpace(),

                /// OK button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cancelButtonBgColor,
                          // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded edges
                          ),
                          elevation: 5, // Shadow
                        ),
                        child: leftButtonMessage
                            .titleMedium(
                                color: AppColors.cancelStyle, size: 12.sp)
                            .paddingAll(padding: AppDimensions.smallXL.w),
                      ),
                    ),
                    AppDimensions.mediumXL.hSpace(),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => onConfirm(),
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: AppColors.errorColor,
                          backgroundColor: AppColors.errorColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8.0), // Rounded edges
                          ),
                          elevation: 5, // Shadow
                        ),
                        child: rightButtonMessage
                            .titleMedium(color: AppColors.white, size: 12.sp)
                            .paddingAll(padding: AppDimensions.smallXL.w),
                      ),
                    ),
                  ],
                ).symmetricPadding(horizontal: AppDimensions.mediumXL),

                /// Vertical space below the OK button
                AppDimensions.xxl.vSpace(),
              ],
            ),
          );
        });
  }

  static Future<bool> checkToken() {
    SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

    // Initialize SharedPreferencesHelper and wait for initialization
    return initializeSharedPreferencesHelper(preferencesHelper);
  }

  static Future<bool> initializeSharedPreferencesHelper(
      SharedPreferencesHelper preferencesHelper) async {
    // Initialize SharedPreferencesHelper and wait for initialization
    await preferencesHelper.init();

    // Use SharedPreferencesHelper to get the token
    var authToken = preferencesHelper.getString(PrefConstKeys.accessToken);
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

  static String convertDateFormatToAnother(
      String inputDateFormat, String outputDateFormat, String input) {
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
    String formattedResult =
        result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);

    String title = formattedResult == "1"
        ? WalletKeys.day.stringToString
        : WalletKeys.days.stringToString;
    return '$formattedResult $title';
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

  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)); // Copy text to clipboard
    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to Clipboard')),
    );*/
  }

  static clearSession() {
    sl<SharedPreferencesHelper>().sharedPreferences.clear();
  }

  static disposeAllBlocs(BuildContext context) {
    if (kDebugMode) {
      print("All Blocs Dispose in progress");
    }
    BlocProvider.of<ChooseDomainBloc>(context, listen: false).domains.clear();
    BlocProvider.of<CategoriesBloc>(context, listen: false).categories.clear();
    BlocProvider.of<CategoriesBloc>(context, listen: false)
        .selectedCategories
        .clear();
    BlocProvider.of<SeekerProfileBloc>(context, listen: false).userData = null;
    BlocProvider.of<AgentProfileBloc>(context, listen: false).userData = null;
    var translationBloc =
        BlocProvider.of<TranslationBloc>(context, listen: false);
    translationBloc.recommendedLangModel = null;
    translationBloc.selectedModel = null;
    translationBloc.translationTextMap.clear();
    translationBloc.langModel.clear();
    BlocProvider.of<SeekerHomeBloc>(context, listen: false).providers.clear();

    if (kDebugMode) {
      print("All Blocs Dispose in done");
    }
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

  static String handleError(Object error) {
    String errorDescription = "";

    if (error is DioException) {
      DioException dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorDescription = ExceptionErrors.requestCancelError.stringToString;

          return errorDescription;
        case DioExceptionType.connectionTimeout:
          errorDescription =
              ExceptionErrors.connectionTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.unknown:
          errorDescription =
              ExceptionErrors.unknownConnectionError.stringToString;

          return errorDescription;
        case DioExceptionType.receiveTimeout:
          errorDescription = ExceptionErrors.receiveTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print(
                "${ExceptionErrors.badResponseError}  ${dioError.response!.data}");
          }
          return dioError.response!.data['message'];

        case DioExceptionType.sendTimeout:
          errorDescription = ExceptionErrors.sendTimeOutError.stringToString;

          return errorDescription;
        case DioExceptionType.badCertificate:
          errorDescription = ExceptionErrors.badCertificate.stringToString;

          return errorDescription;
        case DioExceptionType.connectionError:
          errorDescription =
              ExceptionErrors.checkInternetConnection.stringToString;

          return errorDescription;
      }
    } else {
      errorDescription = ExceptionErrors.unexpectedErrorOccurred.stringToString;
      return errorDescription;
    }
  }
}
