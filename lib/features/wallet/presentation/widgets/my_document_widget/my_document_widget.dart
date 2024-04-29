import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/wallet/domain/entities/wallet_vc_list_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';

import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/space.dart';
import '../../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../../blocs/wallet_vc_bloc/wallet_vc_state.dart';
import '../../widgets/document_widget.dart';
import '../share_dialog.dart';

class MyDocumentWidget extends StatefulWidget {
  const MyDocumentWidget({super.key});

  @override
  State<MyDocumentWidget> createState() => _MyDocumentWidgetState();
}

class _MyDocumentWidgetState extends State<MyDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletVcBloc, WalletVcState>(listener: (context, state) {
      /*if (state is DelWalletSuccessState) {
        print("asddas ");
        context.read<WalletVcBloc>().add(const GetWalletVcEvent());
      }*/
    }, child: BlocBuilder<WalletVcBloc, WalletVcState>(builder: (context, state) {
      return (state is WalletVcSuccessState)
          ? _docVcWidgets(docVc: state.vcData, selectedDocs: [])
          : (state is WalletDocumentSelectedState)
              ? _docVcWidgets(
                  docVc: state.docs,
                  selectedDocs: state.selectedDocs,
                )
              : (state is WalletDocumentUnSelectedState)
                  ? _docVcWidgets(docVc: state.vcData, selectedDocs: [])
                  : Container();
    }));
  }

  _docVcWidgets({
    required List<DocumentVcData> docVc,
    required List<DocumentVcData> selectedDocs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'My Documents'.titleExtraBold(
              size: 20.sp,
            ),
            selectedDocs.isNotEmpty
                ? Row(
                    children: [
                      InkWell(
                          onTap: () {
                            _showMultiShareDialog(context, selectedDocs);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.share_outlined,
                                color: AppColors.blue1E88E5,
                              ),
                              AppDimensions.extraSmall.hSpace(),
                              'Share'.titleBold(size: 14.sp, color: AppColors.blue1E88E5)
                            ],
                          )),
                      AppDimensions.smallXL.hSpace(),
                      InkWell(
                          onTap: () {
                            AppUtils.showAlertDialogForConfirmation(
                                context, 'Delete', 'Are you sure, you want to delete file?', 'Cancel', 'Delete',
                                onConfirm: () {
                              List<String> vc = [];
                              for (DocumentVcData selectedDocs in selectedDocs) {
                                vc.add(selectedDocs.id);
                              }
                              context.read<WalletVcBloc>().add(
                                    WalletDelVcEvent(vcIds: vc),
                                  );
                              Navigator.pop(context);
                            });
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(Assets.images.deleteIcon),
                              AppDimensions.extraSmall.hSpace(),
                              'Delete'.titleBold(size: 14.sp, color: AppColors.redF04438)
                            ],
                          )),
                    ],
                  )
                : Container(),
          ],
        ),
        AppDimensions.medium.vSpace(),
        Expanded(
          child: GridView.count(
            childAspectRatio: 1 / 1.05,
            crossAxisCount: 2,
            children: docVc.asMap().entries.map((entry) {
              final index = entry.key;
              final doc = entry.value;
              return DocumentWidget(
                doc: doc,
                onSelect: (result) {
                  context
                      .read<WalletVcBloc>()
                      .add(WalletDocumentSelectedEvent(position: index, isSelected: result ?? false));
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  void _showMultiShareDialog(BuildContext context, List<DocumentVcData> documentsVcData) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ShareDialogWidget(
            onConfirmPressed: () {},
            documentVcData: null,
            docsList: documentsVcData,
          );
        });
  }
}
