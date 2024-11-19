import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/custom_confirmation_dialog.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../blocs/add_document_bloc/add_document_bloc.dart';
import '../blocs/add_document_bloc/add_document_event.dart';
import '../blocs/add_document_bloc/add_document_state.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_event.dart';
import 'tags_widget.dart';
import 'upload_file_widget.dart';

/// Widget for adding a document view.
class AddDocumentView extends StatefulWidget {
  const AddDocumentView({super.key});

  @override
  State<AddDocumentView> createState() => _AddDocumentViewState();
}

/// State class for [AddDocumentView].
class _AddDocumentViewState extends State<AddDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
        child: BlocListener<AddDocumentsBloc, AddDocumentsState>(
          listener: (context, state) {
            // Listen for state changes to handle document upload success or failure
            if (state is DocumentUploadedState) {
              Navigator.pop(context);
              context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
              documentUploadSuccessfulDialog();
            } else if (state is DocumentUploadFailState) {
              context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
              Navigator.pop(context);
              documentUploadFailedDialog();
            }
          },
          child: BlocBuilder<AddDocumentsBloc, AddDocumentsState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _content(context)),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const Spacer(),
                        ButtonWidget(
                          // Customize button text based on state
                          customText: state is DocumentLoaderState
                              ? WalletKeys.pleaseWait.stringToString
                                  .buttonTextBold(size: AppDimensions.smallXXL.sp, color: AppColors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WalletKeys.addDocument.stringToString
                                        .buttonTextBold(size: AppDimensions.smallXXL.sp, color: AppColors.white),
                                    AppDimensions.extraSmall.w.horizontalSpace,
                                    SvgPicture.asset(
                                      Assets.images.add,
                                      height: 15.h,
                                      width: 15.w,
                                    ),
                                  ],
                                ),
                          // Determine button validity based on state
                          isValid: state is ValidState && state.allDone || state is DocumentLoaderState,
                          onPressed: () async {
                            if (state is DocumentLoaderState) {
                              return;
                            }
                            context.read<AddDocumentsBloc>().add(const AddDocumentSubmittedEvent());
                          },
                        ).symmetricPadding(
                          horizontal: AppDimensions.mediumXL,
                          vertical: AppDimensions.smallXL,
                        ),
                        AppDimensions.extraLarge.verticalSpace
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Widget for rendering the main content of the view.
  Widget _content(BuildContext context) {
    return Column(
      children: [
        // Common top header widget
        CommonTopHeader(
          backgroundColor: Colors.transparent,
          title: WalletKeys.addDocument.stringToString,
          onBackButtonPressed: () {
            context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
            Navigator.pop(context);
          },
          dividerColor: Colors.transparent,
        ),
        // Upload file widget and tags widget
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UploadFileWidget(),
            AppDimensions.smallXL.verticalSpace,
            const TagsWidget(),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.mediumXL,
          vertical: AppDimensions.smallXL,
        ),
      ],
    );
  }

  /// Shows a dialog indicating successful document upload.
  void documentUploadSuccessfulDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: WalletKeys.documentUploaded.stringToString.titleExtraBold(
            color: AppColors.countryCodeColor,
            size: AppDimensions.mediumXL.sp,
            align: TextAlign.center,
          ),
          message: WalletKeys.documentUploadedMessage.stringToString.titleRegular(
            size: AppDimensions.smallXXL.sp,
            color: AppColors.grey64697a,
            align: TextAlign.center,
          ),
          onConfirmPressed: () {
            context.read<WalletVcBloc>().add(const GetWalletVcEvent());
            Navigator.of(context).pop();
          },
          assetPath: Assets.images.icKycSuccess,
        );
      },
    );
  }

  /// Shows a dialog indicating failed document upload.
  void documentUploadFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: WalletKeys.documentUploadFailed.stringToString.titleExtraBold(
            color: AppColors.countryCodeColor,
            size: AppDimensions.mediumXL.sp,
            align: TextAlign.center,
          ),
          buttonTitle: WalletKeys.tryAgain.stringToString,
          message: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WalletKeys.documentUploadFailedMessage.stringToString.titleRegular(
                size: AppDimensions.smallXXL.sp,
                color: AppColors.grey64697a,
                align: TextAlign.center,
              ),
              AppDimensions.small.verticalSpace,
              RichText(
                text: TextSpan(
                  children: [
                    '${WalletKeys.forAssistance.stringToString} '.textSpanRegular(color: AppColors.grey64697a),
                    WalletKeys.contactSupport.stringToString.textSpanSemiBold(
                      decoration: TextDecoration.underline,
                    ),
                  ],
                ),
              ),
            ],
          ),
          onConfirmPressed: () {
            context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
            Navigator.pop(context);
          },
          assetPath: Assets.images.icKycFail,
        );
      },
    );
  }
}
