import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/custom_confirmation_dialog.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/space.dart';
import '../../../../utils/widgets/build_button.dart';
import '../blocs/add_document_bloc/add_document_bloc.dart';
import '../blocs/add_document_bloc/add_document_event.dart';
import '../blocs/add_document_bloc/add_document_state.dart';
import 'tags_widget.dart';
import 'upload_file_widget.dart';

class AddDocumentDialogWidget extends StatefulWidget {
  const AddDocumentDialogWidget({super.key});

  @override
  State<AddDocumentDialogWidget> createState() => _AddDocumentDialogWidgetState();
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
      insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
      child: SingleChildScrollView(child: _content(context)),
    );
  }

  Widget _content(BuildContext context) {
    return BlocListener<AddDocumentsBloc, AddDocumentsState>(listener: (context, state) {
      if (state is DocumentUploadedState) {
        Navigator.pop(context);
        context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
        documentUploadSuccessfulDialog();
      } else if (state is DocumentUploadFailState) {
        context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
        Navigator.pop(context);
        documentUploadFailedDialog();
      }
    }, child: BlocBuilder<AddDocumentsBloc, AddDocumentsState>(builder: (context, state) {
      return Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  'Add Document'.titleExtraBold(size: 20.sp),
                  GestureDetector(
                      onTap: () {
                        context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
                        // Close the dialog
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: SvgPicture.asset(Assets.images.cross)
                            .symmetricPadding(horizontal: AppDimensions.mediumXL, vertical: AppDimensions.medium),
                      )),
                ],
              ).singleSidePadding(
                left: AppDimensions.mediumXL,
                top: AppDimensions.smallXL,
              ),
              const Divider(color: AppColors.hintColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UploadFileWidget(),
                  AppDimensions.smallXL.vSpace(),
                  const TagsWidget(),
                  AppDimensions.large.vSpace(),
                  ButtonWidget(
                      title: state is DocumentLoaderState ? "Please wait..." : 'Add Document',
                      isValid: state is ValidState && state.allDone || state is DocumentLoaderState,
                      onPressed: () async {
                        if (state is DocumentLoaderState) {
                          return;
                        }
                        context.read<AddDocumentsBloc>().add(const AddDocumentSubmittedEvent());
                      }),
                  AppDimensions.medium.vSpace(),
                ],
              ).symmetricPadding(
                horizontal: AppDimensions.mediumXL,
                vertical: AppDimensions.smallXL,
              ),
            ],
          ),
        ],
      );
    }));
  }

  void documentUploadSuccessfulDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                'Document Uploaded'.titleExtraBold(
                  color: AppColors.countryCodeColor,
                  size: 20.sp,
                ),
                2.vSpace(),
                'Successfully!'.titleExtraBold(
                  color: AppColors.countryCodeColor,
                  size: 20.sp,
                ),
              ],
            ),
            message: 'Your document has been successfully uploaded.'
                .titleRegular(size: 14.sp, color: AppColors.black, align: TextAlign.center),
            onConfirmPressed: () {
              context.read<WalletVcBloc>().add(const GetWalletVcEvent());

              Navigator.of(context).pop();
            },
            assetPath: Assets.images.successIcon,
          );
        });
  }

  void documentUploadFailedDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: 'Document Upload Failed!'.titleExtraBold(
              color: AppColors.countryCodeColor,
              size: 20.sp,
            ),
            message: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                'An error occurred while uploading the file. Please try again later.'
                    .titleRegular(size: 14.sp, color: AppColors.alertDialogMessageColor, align: TextAlign.center),
                RichText(
                  text: TextSpan(
                    children: [
                      'For assistance, '.textSpanRegular(),
                      'contact support.'.textSpanSemiBold(decoration: TextDecoration.underline),
                    ],
                  ),
                ),
              ],
            ),
            buttonTitle: 'Retry',
            onConfirmPressed: () {
              context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
              Navigator.pop(context);
            },
            assetPath: Assets.images.kycFailIcon,
          );
        });
  }
}
