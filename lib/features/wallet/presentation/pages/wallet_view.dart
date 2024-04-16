import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/add_document_dialog_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/custom_confirmation_dialog.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/widgets/build_button.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.images.noDocumentsAdded),
              AppDimensions.mediumXL.vSpace(),
              'No Documents Added!'.titleExtraBold(
                color: AppColors.black,
                size: 20.sp,
              ),
              AppDimensions.small.vSpace(),
              'There is no document added yet.'
                  .titleRegular(size: 14.sp, color: AppColors.black),
              'Please add a document.'
                  .titleRegular(size: 14.sp, color: AppColors.black),
              AppDimensions.smallXL.vSpace(),
              ButtonWidget(
                title: 'Add Document',
                isValid: true,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AddDocumentDialogWidget();
                      });
                },
              ).symmetricPadding(horizontal: 69.w),
            ],
          ),
        )
      ],
    );
  }

  void documentUploadSuccessfulDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: 'Document Upload Successfully!',
            message: 'Your document has been successfully uploaded.'
                .titleRegular(size: 14.sp, color: AppColors.black),
            onConfirmPressed: () => Navigator.of(context).pop(),
            assetPath: Assets.images.successIcon,
          );
        });
  }

  void documentUploadFailedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: 'Document Upload Failed!',
            message: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                'An error occurred while uploading the file. Please try again later.'
                    .titleRegular(
                        size: 14.sp,
                        color: AppColors.alertDialogMessageColor,
                        align: TextAlign.center),
                RichText(
                  text: TextSpan(
                    children: [
                      'For assistance, '.textSpanRegular(),
                      'contact support.'.textSpanSemiBold(
                          decoration: TextDecoration.underline),
                    ],
                  ),
                ),
              ],
            ),
            buttonTitle: 'Retry',
            onConfirmPressed: () => Navigator.of(context).pop(),
            assetPath: Assets.images.kycFailIcon,
          );
        });
  }
}
