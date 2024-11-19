import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/widgets/pdf_view_page.dart';
import 'package:xplor/features/wallet/presentation/widgets/tags_list_widget.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../domain/entities/wallet_vc_list_entity.dart';

import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_event.dart';

/// Document Widget
class DocumentWidget extends StatelessWidget {
  final Function(bool?) onSelect; // Callback for selection changes
  final DocumentVcData doc; // Document data to display

  const DocumentWidget({super.key, required this.doc, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedDocVcBloc, SharedDocVcState>(builder: (context, state) {
      return Card(
        elevation: AppDimensions.extraSmall.w,
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        child: Stack(
          children: [
            // Column for laying out document details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row containing the selection icon and PDF thumbnail
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Selection icon (radio button or custom SVG)
                    InkWell(
                      onTap: () => onSelect(!(doc.isSelected ?? false)),
                      splashColor: Colors.transparent,
                      child: doc.isSelected ?? false
                          ? SvgPicture.asset(Assets.images.icSelected,
                              height: AppDimensions.mediumXL.w, width: AppDimensions.mediumXL.w)
                          : Icon(
                              Icons.radio_button_off_outlined,
                              size: AppDimensions.mediumXL.w,
                              color: AppColors.greyBorderC1,
                            ),
                    ),
                    Expanded(
                      child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewWidget(doc: doc),
                                  ),
                                );
                              },
                              child: doc.fileType == "text/html"
                                  ? AppUtils.loadText(
                                      doc.tags,
                                    )
                                  : SvgPicture.asset(
                                      AppUtils.loadThumbnailBasedOnMimeTime(doc.fileType!),
                                      height: 60.w,
                                      width: 44.w,
                                    ))
                          .singleSidePadding(right: 20.w, top: AppDimensions.small.w),
                    )
                  ],
                ),
                doc.fileType == "text/html"
                    ? AppDimensions.extraSmall.verticalSpace
                    : AppDimensions.mediumXL.verticalSpace,
                // Verified icon
                SvgPicture.asset(Assets.images.icVerified, height: AppDimensions.medium.w, width: 56.w),
                AppDimensions.extraSmall.verticalSpace,
                // Document title
                doc.name.titleBoldWithDots(size: AppDimensions.smallXXL.sp, maxLine: 1),
                AppDimensions.small.verticalSpace,
                // List of tags
                TagListWidgets(tags: doc.tags),
              ],
            ).paddingAll(padding: AppDimensions.smallXL.w),

            // Conditional Popup menu for sharing or deleting document
            context.read<WalletVcBloc>().flowType == FlowType.document ||
                    context.read<WalletVcBloc>().flowType == FlowType.consent
                ? Builder(
                    builder: (mCtx) => StatefulBuilder(
                      builder: (ctx, setState) => Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            // Get the render box position for positioning the popup menu
                            RenderBox renderBox = ctx.findRenderObject() as RenderBox;
                            Offset offset = renderBox.localToGlobal(Offset.zero);
                            // Show the menu with options to share or delete
                            showMenu(
                              context: ctx,
                              position: RelativeRect.fromLTRB(
                                offset.dx,
                                offset.dy + renderBox.size.height,
                                offset.dx + renderBox.size.width,
                                offset.dy + renderBox.size.height + 10, // Adjust the vertical spacing as needed
                              ),
                              items: [
                                // Share option
                                PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.share_outlined, color: Colors.black),
                                      const SizedBox(width: AppDimensions.small),
                                      Text(WalletKeys.share.stringToString),
                                    ],
                                  ),
                                  onTap: () {
                                    context.read<WalletVcBloc>().flowType = FlowType.document;
                                    context.read<SharedDocVcBloc>().add(ShareDocumentsEvent(documentVcData: doc));
                                    Navigator.pushNamed(context, Routes.shareDocument);
                                  },
                                ),
                                // Delete option
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        Assets.images.deleteIcon,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(WalletKeys.delete.stringToString),
                                    ],
                                  ),
                                  onTap: () {
                                    AppUtils.showAlertDialogForConfirmation(
                                      ctx,
                                      WalletKeys.delete.stringToString,
                                      '${WalletKeys.deleteMessage.stringToString}?',
                                      WalletKeys.cancel.stringToString,
                                      WalletKeys.delete.stringToString,
                                      onConfirm: () {
                                        List<String> vc = [];
                                        vc.add(doc.id);
                                        context.read<WalletVcBloc>().add(
                                              WalletDelVcEvent(vcIds: vc),
                                            );
                                        Navigator.pop(ctx);
                                      },
                                    );
                                  },
                                ),
                              ],
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                            ).then((value) {
                              // Handle the selected action here
                              if (value == 'share') {
                                // Perform share action
                              } else if (value == 'delete') {
                                // Perform delete action
                              }
                            });
                          },
                          child: const Icon(
                              size: AppDimensions.mediumXL, Icons.more_vert, color: AppColors.primaryLightColor),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    });
  }
}
