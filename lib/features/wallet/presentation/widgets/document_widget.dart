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

class DocumentWidget extends StatelessWidget {
  final Function(bool?) onSelect;
  final DocumentVcData doc;

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
            // Your grid item content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        onSelect(!(doc.isSelected ?? false));
                      },
                      splashColor: Colors.transparent,
                      child: doc.isSelected ?? false
                          ? SvgPicture.asset(
                              Assets.images.icSelected,
                              height: 20.w,
                              width: 20.w,
                            )
                          : Icon(
                              Icons.radio_button_off_outlined,
                              size: AppDimensions.mediumXL.w,
                              color: AppColors.greyBorderC1,
                            ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewWidget(doc: doc),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          AppUtils.loadThumbnailBasedOnMimeTime(doc.fileType!),
                          height: 60.w,
                          width: 44.w,
                        )).singleSidePadding(right: 50.w, top: AppDimensions.small.w),
                  ],
                ),
                AppDimensions.mediumXL.verticalSpace,
                SvgPicture.asset(
                  Assets.images.icVerified,
                  height: 16.w,
                  width: 56.w,
                ),
                AppDimensions.extraSmall.vSpace(),
                doc.name.titleBoldWithDots(size: 14.sp, maxLine: 1),
                AppDimensions.small.vSpace(),
                TagListWidgets(tags: doc.tags),
              ],
            ).paddingAll(padding: AppDimensions.smallXL.w),
            // Popup menu
            context.read<WalletVcBloc>().flowType == FlowType.document ||
                    context.read<WalletVcBloc>().flowType == FlowType.consent
                ? Builder(
                    builder: (mCtx) => StatefulBuilder(
                      builder: (ctx, setState) => Positioned(
                        top: 10.0,
                        right: 10.0,
                        child: GestureDetector(
                          onTap: () {
                            RenderBox renderBox = ctx.findRenderObject() as RenderBox;
                            Offset offset = renderBox.localToGlobal(Offset.zero);
                            showMenu(
                                    context: ctx,
                                    position: RelativeRect.fromLTRB(
                                      offset.dx,
                                      offset.dy + renderBox.size.height,
                                      offset.dx + renderBox.size.width,
                                      offset.dy + renderBox.size.height + 10, // Adjust the vertical spacing as needed
                                    ),
                                    items: [
                                      PopupMenuItem(
                                        value: 'share',
                                        child: Row(
                                          children: [
                                            const Icon(Icons.share_outlined, color: Colors.black),
                                            const SizedBox(width: 8),
                                            Text(WalletKeys.share.stringToString),
                                          ],
                                        ),
                                        onTap: () {
                                          context.read<WalletVcBloc>().flowType = FlowType.document;
                                          context.read<SharedDocVcBloc>().add(ShareDocumentsEvent(documentVcData: doc));
                                          Navigator.pushNamed(context, Routes.shareDocument);
                                        },
                                      ),
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
                                              WalletKeys.delete.stringToString, onConfirm: () {
                                            List<String> vc = [];

                                            vc.add(doc.id);

                                            context.read<WalletVcBloc>().add(WalletDelVcEvent(
                                                  vcIds: vc,
                                                ));

                                            Navigator.pop(ctx);
                                          });
                                        },
                                      ),
                                    ],
                                    color: Colors.white,
                                    surfaceTintColor: Colors.white)
                                .then((value) {
                              // Handle the selected action here
                              if (value == 'share') {
                                // Perform share action
                              } else if (value == 'delete') {
                                // Perform delete action
                              }
                            });
                          },
                          child: const Icon(
                            size: 20,
                            Icons.more_vert,
                            color: AppColors.primaryLightColor,
                          ),
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
