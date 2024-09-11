import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../domain/entities/wallet_vc_list_entity.dart';
import '../../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../../blocs/wallet_vc_bloc/wallet_vc_event.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../../blocs/wallet_vc_bloc/wallet_vc_state.dart';
import '../../pages/wallet_no_doc_view.dart';
import '../../widgets/document_widget.dart';

/// My Document Widget
class MyDocumentWidget extends StatefulWidget {
  const MyDocumentWidget({super.key});

  @override
  State<MyDocumentWidget> createState() => _MyDocumentWidgetState();
}

/// searchController
TextEditingController searchController = TextEditingController();

class _MyDocumentWidgetState extends State<MyDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletVcBloc, WalletVcState>(listener: (context, state) {
      if (state is DelWalletSuccessState) {
        context.read<WalletVcBloc>().add(const GetWalletVcEvent());
      }
      if (state is WalletVcFailureState) {
        AppUtils.showSnackBar(context, state.message.toString());
      }
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
                  : (state is WalletDocumentsSearchedState)
                      ? _docVcWidgets(
                          docVc: state.searchedDocuments, isSearchData: true, selectedDocs: state.selectedDocuments)
                      : Container();
    }));
  }

  /// _docVcWidgets
  Widget _docVcWidgets({
    required List<DocumentVcData> docVc,
    required List<DocumentVcData> selectedDocs,
    bool isSearchData = false,
  }) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.images.icSearch,
                height: 18.w,
                width: 18.w,
              ),
              AppDimensions.medium.w.horizontalSpace,
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColors.grey9898a5),
                    hintText: WalletKeys.searchSomething.stringToString,
                    border: InputBorder.none,
                  ),
                  onChanged: (input) {
                    if (input == '') {
                      context.read<WalletVcBloc>().add(WalletSearchDocumentsEvent(documentsName: input));
                    }
                  },
                  onFieldSubmitted: (search) {
                    context.read<WalletVcBloc>().add(WalletSearchDocumentsEvent(documentsName: search));
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                  // Add functionality for mic icon tap
                },
                child: SvgPicture.asset(
                  Assets.images.icMic,
                  height: AppDimensions.mediumXL.w,
                  width: AppDimensions.smallXL.w,
                ),
              ),
            ],
          ).symmetricPadding(
            vertical: AppDimensions.extraExtraSmall.w,
            horizontal: AppDimensions.medium.w,
          ),
        )),
        SliverToBoxAdapter(
          child: Row(
            children: [
              WalletKeys.myDocuments.stringToString
                  .titleExtraBold(size: 20.sp, color: AppColors.grey6469)
                  .singleSidePadding(top: AppDimensions.medium, bottom: AppDimensions.medium),
              const Spacer(),
              if (selectedDocs.isNotEmpty &&
                  (context.read<WalletVcBloc>().flowType == FlowType.document ||
                      context.read<WalletVcBloc>().flowType == FlowType.consent))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<WalletVcBloc>().flowType = FlowType.document;
                        _navigateToMultiShareDialog(context, selectedDocs);
                      },
                      child: Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(
                              top: AppDimensions.medium,
                              bottom: AppDimensions.medium,
                              left: AppDimensions.medium,
                              right: AppDimensions.small,
                            ),
                            child: SvgPicture.asset(
                              Assets.images.icShare,
                              colorFilter: const ColorFilter.mode(
                                AppColors.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppUtils.showAlertDialogForConfirmation(
                          context,
                          WalletKeys.delete.stringToString,
                          '${WalletKeys.deleteMessage.stringToString}?',
                          WalletKeys.cancel.stringToString,
                          WalletKeys.delete.stringToString,
                          onConfirm: () {
                            List<String> vc = [];
                            for (DocumentVcData selectedDoc in selectedDocs) {
                              vc.add(selectedDoc.id);
                            }
                            context.read<WalletVcBloc>().add(
                                  WalletDelVcEvent(vcIds: vc),
                                );
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.only(
                              top: AppDimensions.medium,
                              bottom: AppDimensions.medium,
                              left: AppDimensions.small,
                              right: AppDimensions.medium,
                            ),
                            child: SvgPicture.asset(
                              Assets.images.deleteIcon,
                              colorFilter: const ColorFilter.mode(
                                AppColors.redColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (docVc.isEmpty && isSearchData)
          SliverFillRemaining(
            hasScrollBody: false,
            child: WalletNoDocumentView(
              title: WalletKeys.noRecordFound.stringToString,
              isSearchEnabled: true,
            ),
          )
        else
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppDimensions.smallXXL.w,
              mainAxisSpacing: AppDimensions.smallXXL.w,
              childAspectRatio: 1 / 1.09,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final doc = docVc[index];
                return DocumentWidget(
                  doc: doc,
                  onSelect: (result) {
                    context.read<WalletVcBloc>().add(
                          WalletDocumentSelectedEvent(
                            position: index,
                            isSelected: result ?? false,
                            id: doc.id,
                          ),
                        );
                  },
                );
              },
              childCount: docVc.length,
            ),
          )
      ],
    );
  }

/*  _docVcWidgets(
      {required List<DocumentVcData> docVc,
      required List<DocumentVcData> selectedDocs,
      bool isSearchData = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.images.icSearch,
                height: 18.w,
                width: 18.w,
              ),
              AppDimensions.medium.w.horizontalSpace,
              // Add spacing between the icon and text field
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: AppColors.grey9898a5),
                    hintText: WalletKeys.searchSomething.stringToString,
                    border:
                        InputBorder.none, // Remove the border of the text field
                  ),
                  onChanged: (input) {
                    if (input == '') {
                      context.read<WalletVcBloc>().add(
                          WalletSearchDocumentsEvent(documentsName: input));
                    }
                  },
                  onFieldSubmitted: (search) {
                    context
                        .read<WalletVcBloc>()
                        .add(WalletSearchDocumentsEvent(documentsName: search));
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              // Add spacing between the text field and mic icon
              GestureDetector(
                onTap: () {
                  // Add functionality for mic icon tap
                },
                child: SvgPicture.asset(
                  Assets.images.icMic,
                  height: AppDimensions.mediumXL,
                  width: AppDimensions.smallXL.w,
                ),
              ),
            ],
          ).symmetricPadding(
              vertical: AppDimensions.extraExtraSmall.w,
              horizontal: AppDimensions.medium.w),
        ),
        Row(
          children: [
            WalletKeys.myDocuments.stringToString
                .titleExtraBold(size: 20.sp, color: AppColors.grey6469)
                .singleSidePadding(
                    top: AppDimensions.medium, bottom: AppDimensions.medium),
            const Spacer(),
            (selectedDocs.isNotEmpty &&
                    (context.read<WalletVcBloc>().flowType ==
                            FlowType.document ||
                        context.read<WalletVcBloc>().flowType ==
                            FlowType.consent))
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            context.read<WalletVcBloc>().flowType =
                                FlowType.document;
                            _navigateToMultiShareDialog(context, selectedDocs);
                          },
                          child: Row(
                            children: [
                              Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.only(
                                  top: AppDimensions.medium,
                                  bottom: AppDimensions.medium,
                                  left: AppDimensions.medium,
                                  right: AppDimensions.small,
                                ),
                                child: SvgPicture.asset(
                                  Assets.images.icShare,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              */ /*AppDimensions.extraSmall.w.horizontalSpace,
                              WalletKeys.share.stringToString.titleBold(
                                  size: 14.sp, color: AppColors.blue1E88E5)*/ /*
                            ],
                          )),
                      //AppDimensions.smallXL.w.horizontalSpace,
                      InkWell(
                          onTap: () {
                            AppUtils.showAlertDialogForConfirmation(
                                context,
                                WalletKeys.delete.stringToString,
                                '${WalletKeys.deleteMessage.stringToString}?',
                                WalletKeys.cancel.stringToString,
                                WalletKeys.delete.stringToString,
                                onConfirm: () {
                              List<String> vc = [];
                              for (DocumentVcData selectedDocs
                                  in selectedDocs) {
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
                              Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.only(
                                  top: AppDimensions.medium,
                                  bottom: AppDimensions.medium,
                                  left: AppDimensions.small,
                                  right: AppDimensions.medium,
                                ),
                                child: SvgPicture.asset(
                                  Assets.images.deleteIcon,
                                  color: AppColors.redColor,
                                ),
                              ),
                              */ /* AppDimensions.extraSmall.w.horizontalSpace,
                              WalletKeys.delete.stringToString.titleBold(
                                  size: 14.sp, color: AppColors.redF04438)*/ /*
                            ],
                          )),
                    ],
                  )
                : Container(),
          ],
        ),
        Expanded(child: docVc.isNotEmpty && isSearchData
            ? SizedBox(
          height: 200,
          child: WalletNoDocumentView(
            title: WalletKeys.noRecordFound.stringToString,
            isSearchEnabled: true,
          ),
        )
            : GridView.count(
          crossAxisSpacing: AppDimensions.smallXXL.w,
          mainAxisSpacing: AppDimensions.smallXXL.w,
          childAspectRatio: 1 / 1.09,
          crossAxisCount: 2,
          children: docVc.asMap().entries.map((entry) {
            final index = entry.key;
            final doc = entry.value;
            return DocumentWidget(
              doc: doc,
              onSelect: (result) {
                context.read<WalletVcBloc>().add(
                    WalletDocumentSelectedEvent(
                        position: index,
                        isSelected: result ?? false,
                        id: doc.id ?? ''));
              },
            );
          }).toList(),
        ),)
      ],
    );
  }*/

  /// Navigate to share document screen
  void _navigateToMultiShareDialog(BuildContext context, List<DocumentVcData> documentsVcData) {
    context.read<SharedDocVcBloc>().add(ShareDocumentsEvent(selectedDocs: documentsVcData));
    Navigator.pushNamed(context, Routes.shareDocument);
  }
}
