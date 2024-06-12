import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';

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

class AddDocumentView extends StatefulWidget {
  const AddDocumentView({super.key});

  @override
  State<AddDocumentView> createState() => _AddDocumentViewState();
}

class _AddDocumentViewState extends State<AddDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AppBackgroundDecoration(
      child: BlocListener<AddDocumentsBloc, AddDocumentsState>(listener: (context, state) {
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
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: _content(context)),
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Spacer(),
                  ButtonWidget(
                    customText: state is DocumentLoaderState
                        ? WalletKeys.pleaseWait.stringToString.buttonTextBold(size: 14.sp, color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              WalletKeys.addDocument.stringToString.buttonTextBold(size: 14.sp, color: Colors.white),
                              AppDimensions.extraSmall.hSpace(),
                              SvgPicture.asset(
                                Assets.images.add,
                                height: 15.h,
                                width: 15.w,
                              ),
                            ],
                          ),
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
                  AppDimensions.extraLarge.vSpace()
                ],
              )),
        ]);
      })),
    ));
  }

  Widget _content(BuildContext context) {
    return Column(
      children: [
        CommonTopHeader(
            backgroundColor: Colors.transparent,
            title: WalletKeys.addDocument.stringToString,
            onBackButtonPressed: () {
              context.read<AddDocumentsBloc>().add(const AddDocumentInitialEvent());
              Navigator.pop(context);
            },
            dividerColor: Colors.transparent),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UploadFileWidget(),
            AppDimensions.smallXL.vSpace(),
            const TagsWidget(),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.mediumXL,
          vertical: AppDimensions.smallXL,
        ),
      ],
    );
  }

  void documentUploadSuccessfulDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: WalletKeys.documentUploaded.stringToString
                .titleExtraBold(color: AppColors.countryCodeColor, size: 20.sp, align: TextAlign.center),
            message: WalletKeys.documentUploadedMessage.stringToString
                .titleRegular(size: 14.sp, color: AppColors.grey64697a, align: TextAlign.center),
            onConfirmPressed: () {
              context.read<WalletVcBloc>().add(const GetWalletVcEvent());
              Navigator.of(context).pop();
            },
            assetPath: Assets.images.icKycSuccess,
          );
        });
  }

  void documentUploadFailedDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: WalletKeys.documentUploadFailed.stringToString
                .titleExtraBold(color: AppColors.countryCodeColor, size: 20.sp, align: TextAlign.center),
            buttonTitle: WalletKeys.tryAgain.stringToString,
            message: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WalletKeys.documentUploadFailedMessage.stringToString
                    .titleRegular(size: 14.sp, color: AppColors.grey64697a, align: TextAlign.center),
                AppDimensions.small.vSpace(),
                RichText(
                  text: TextSpan(
                    children: [
                      '${WalletKeys.forAssistance.stringToString} '.textSpanRegular(color: AppColors.grey64697a),
                      WalletKeys.contactSupport.stringToString.textSpanSemiBold(decoration: TextDecoration.underline),
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
        });
  }
}
