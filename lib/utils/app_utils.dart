import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'extensions/font_style/font_styles.dart';
import 'extensions/padding.dart';
import '../config/services/app_services.dart';
import '../const/user_define_function.dart';
import 'widgets/build_button.dart';
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

  static void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            titlePadding:
                const EdgeInsets.only(left: 20, right: 10, bottom: 20, top: 6),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                'Exit'.titleExtraBold(size: 20),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.crossIconColor), // Set custom close icon
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child:
                    'Are you sure, you want to exit?\nAll progress will be lost.'
                        .titleSemiBold(size: 16)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        buttonBackgroundColor: AppColors.cancelButtonBgColor,
                        buttonForegroundColor: AppColors.subTitleText,
                        customText: 'Cancel'.titleMedium(
                            size: 12, color: AppColors.subTitleText),
                        isValid: true,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ButtonWidget(
                        fontSize: 12,
                        customText: 'Exit'
                            .titleMedium(size: 12, color: AppColors.white),
                        isValid: true,
                        onPressed: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  /// Dialog to show choose file
  static void chooseFileDialog({required GetMediaData getMediaData}) {
    showCupertinoModalPopup(
      context: AppServices.navState.currentContext!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () async => getMediaData.call(await getMediaFile()),
              child: 'File Manager'.titleRegular(
                color: AppColors.primaryColor,
                size: 18.sp,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async => getMediaData.call(await getMediaFile()),
              child: 'Photo Gallery'.titleRegular(
                color: AppColors.primaryColor,
                size: 18.sp,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async => getMediaData.call(await getMediaFile()),
              child: 'Camera'.titleRegular(
                color: AppColors.primaryColor,
                size: 18.sp,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: 'Cancel'.titleBold(
              color: AppColors.primaryColor,
              size: 18.sp,
            ),
          ),
        ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp);
      },
    );
  }

  static Future<File?> getMediaFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      return file;
    } else {
      return null;
    }
  }
}
