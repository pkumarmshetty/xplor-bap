import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/widgets/pdf_view_page.dart';
import 'package:xplor/features/wallet/presentation/widgets/share_dialog.dart';
import 'package:xplor/features/wallet/presentation/widgets/tags_list_widget.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
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
        surfaceTintColor: Colors.white,
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
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: () {
                          onSelect(!(doc.isSelected ?? false));
                        },
                        splashColor: Colors.transparent,
                        child: Container(
                          width: 18.w,
                          height: 18.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: doc.isSelected ?? false //isSelected
                                  ? AppColors.blue1E88E5
                                  : AppColors.crossIconColor,
                              // We need this for future reference (multi selection doc vc)
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: doc.isSelected ?? false //isSelected
                              ? Icon(
                                  Icons.check,
                                  size: 14,
                                  color: AppColors.blue1E88E5,
                                )
                              : null,
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, right: 70.0),
                        child: SvgPicture.asset(
                          AppUtils.loadThumbnailBasedOnMimeTime(doc.fileType!),
                          height: 60.w,
                          width: 44.w,
                        ),
                      ),
                    ),
                  ],
                ),
                28.verticalSpace,
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SvgPicture.asset(
                    Assets.images.icVerified,
                    height: 12.w,
                    width: 44.w,
                  ),
                ),
                AppDimensions.extraSmall.vSpace(),
                doc.name.titleBoldWithDots(size: 14.sp, maxLine: 1).symmetricPadding(horizontal: AppDimensions.small),
                AppDimensions.extraSmall.vSpace(),
                TagListWidgets(tags: doc.tags).symmetricPadding(horizontal: AppDimensions.small),
                AppDimensions.small.vSpace(),
              ],
            ),
            // Popup menu
            Builder(
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
                                  child: const Row(
                                    children: [
                                      Icon(Icons.share, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text('Share'),
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return ShareDialogWidget(
                                            onConfirmPressed: () {},
                                            documentVcData: doc,
                                          );
                                        });
                                  },
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                  onTap: () {
                                    AppUtils.showAlertDialogForConfirmation(
                                        ctx, 'Delete', 'Are you sure, you want to delete file?', 'Cancel', 'Delete',
                                        onConfirm: () {
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
                              //color: Colors.white,
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
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
