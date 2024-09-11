import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../wallet/domain/entities/wallet_vc_list_entity.dart';
import '../../../wallet/presentation/blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../../../wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../../../wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';
import '../../../wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_state.dart';
import '../../../wallet/presentation/pages/wallet_no_doc_view.dart';
import '../../../wallet/presentation/widgets/my_document_widget/my_document_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';

class CourseDocumentScreen extends StatefulWidget {
  const CourseDocumentScreen({super.key});

  @override
  State<CourseDocumentScreen> createState() => _CourseDocumentScreenState();
}

class _CourseDocumentScreenState extends State<CourseDocumentScreen> {
  @override
  void initState() {
    context.read<WalletVcBloc>().flowType = FlowType.course;
    context.read<WalletVcBloc>().add(const GetWalletVcEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletVcBloc, WalletVcState>(
        listener: (context, state) {},
        child: BlocBuilder<WalletVcBloc, WalletVcState>(builder: (context, state) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                  child: AppBackgroundDecoration(
                      child: ((state is WalletVcSuccessState && state.vcData.isNotEmpty) ||
                              state is WalletDocumentSelectedState ||
                              state is WalletDocumentUnSelectedState ||
                              state is WalletDocumentsSearchedState)
                          ? Stack(children: [
                              Column(
                                children: [
                                  CommonTopHeader(
                                    title: WalletKeys.selectDocument.stringToString,
                                    onBackButtonPressed: () {
                                      context.read<WalletVcBloc>().flowType = FlowType.document;
                                      Navigator.pop(context);
                                    },
                                    dividerColor: AppColors.hintColor,
                                  ),
                                  AppDimensions.medium.verticalSpace,
                                  Expanded(
                                    child:
                                        const MyDocumentWidget().symmetricPadding(horizontal: AppDimensions.mediumXL.w),
                                  ),
                                  AppDimensions.medium.verticalSpace,
                                  continueButton(state),
                                  AppDimensions.small.verticalSpace
                                ],
                              ),
                              Positioned(
                                  right: 0,
                                  bottom: 114.w,
                                  child: ButtonWidget(
                                    width: 58.w,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppDimensions.smallXL.w, vertical: AppDimensions.smallXL.w),
                                    customText: SvgPicture.asset(Assets.images.add),
                                    isValid: true,
                                    onPressed: () => Navigator.pushNamed(context, Routes.addDoument),
                                  ).symmetricPadding(horizontal: AppDimensions.mediumXL.w))
                            ])
                          : state is WalletVcSuccessState && state.vcData.isEmpty
                              ? const WalletNoDocumentView()
                              : state is WalletVcLoadingState
                                  ? const Center(child: LoadingAnimation())
                                  : Container())));
        }));
  }

  Widget continueButton(WalletVcState state) {
    return ButtonWidget(
      onPressed: () async {
        List<DocumentVcData> selectedDocs;
        state is WalletDocumentSelectedState
            ? selectedDocs = state.selectedDocs
            : state is WalletDocumentsSearchedState
                ? selectedDocs = state.selectedDocuments
                : selectedDocs = [];
        selectedDocs.length > 1
            ? context.read<SharedDocVcBloc>().add(ShareDocumentsEvent(selectedDocs: selectedDocs))
            : context.read<SharedDocVcBloc>().add(ShareDocumentsEvent(documentVcData: selectedDocs[0]));
        Navigator.pushNamed(context, Routes.shareDocument);
      },
      title: WalletKeys.continueString.stringToString,
      isValid: ((state is WalletDocumentSelectedState && state.selectedDocs.isNotEmpty) ||
          (state is WalletDocumentsSearchedState && state.selectedDocuments.isNotEmpty)),
    ).symmetricPadding(horizontal: AppDimensions.mediumXL, vertical: AppDimensions.large.w);
  }
}
