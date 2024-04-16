import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/space.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/custom_text_form_fields.dart';

class AddDocumentDialogWidget extends StatefulWidget {
  const AddDocumentDialogWidget({super.key});

  @override
  State<AddDocumentDialogWidget> createState() =>
      _AddDocumentDialogWidgetState();
}

class _AddDocumentDialogWidgetState extends State<AddDocumentDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Setting up dialog shape
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.medium),
      ),
      // Setting background color of the dialog
      backgroundColor: AppColors.white,
      elevation: 0,
      // Adjusting padding inside the dialog
      insetPadding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
      child: SingleChildScrollView(child: _content(context)),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'Add Document'.titleExtraBold(size: 20.sp),
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(Assets.images.cross)),
          ],
        ).padding(
          left: AppDimensions.mediumXL,
          right: AppDimensions.mediumXL,
          top: AppDimensions.smallXL,
        ),
        const Divider(color: AppColors.hintColor),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Select File'.titleBold(size: 14.sp),
            AppDimensions.small.vSpace(),
            GestureDetector(
              onTap: () =>
                  AppUtils.chooseFileDialog(getMediaData: (file) async {
                if (file != null) {
                  Navigator.pop(context);
                }
              }),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.hintColor,
                    style: BorderStyle.solid,
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.mediumXL,
                  horizontal: AppDimensions.large,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(Assets.images.documentUpload),
                    10.85.vSpace(),
                    RichText(
                      text: TextSpan(
                        children: [
                          'Choose '.textSpanSemiBold(),
                          'file to upload'
                              .textSpanRegular(fontWeight: FontWeight.w600),
                        ],
                      ),
                    ),
                    AppDimensions.extraSmall.vSpace(),
                    'Select image,pdf'.titleRegular(size: 12.sp),
                  ],
                ),
              ),
            ),
            AppDimensions.smallXL.vSpace(),
            formContent(),
            AppDimensions.large.vSpace(),
            ButtonWidget(
              title: 'Add Document',
              onPressed: () {},
            ),
            AppDimensions.medium.vSpace(),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.mediumXL,
          vertical: AppDimensions.smallXL,
        ),
      ],
    );
  }

  Widget formContent() {
    return Column(
      children: [
        const CustomTextFormField(
          label: 'File Name',
          hintText: 'Enter File Name',
        ),
        AppDimensions.smallXL.vSpace(),
        const CustomTextFormField(
          label: 'Enter Tags',
          hintText: '(Include comma (,) separated values',
        ),
        AppDimensions.small.vSpace(),
        Row(
          children: [
            'Suggested Tags:'
                .titleRegular(size: 14.sp, color: AppColors.hintColor),
            AppDimensions.extraSmall.hSpace(),
            tagsWidget(tag: 'Scholarship'),
            AppDimensions.extraSmall.hSpace(),
            tagsWidget(tag: 'Admission'),
            AppDimensions.extraSmall.hSpace(),
            tagsWidget(tag: 'Job'),
          ],
        ),
      ],
    );
  }

  Widget tagsWidget({required String tag}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(49.27.sp),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.small,
        horizontal: 6,
      ),
      child: tag.titleSemiBold(size: 10.sp),
    );
  }
}
