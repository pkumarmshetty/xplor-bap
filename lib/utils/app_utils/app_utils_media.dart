part of 'app_utils.dart';

mixin AppUtilsMediaMixin {
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
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      return file;
    } else {
      return null;
    }
  }
}
