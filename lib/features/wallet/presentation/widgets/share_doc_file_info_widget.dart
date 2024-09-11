import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import 'tags_list_widget.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';

class ShareDocFileInfoWidget extends StatelessWidget {
  const ShareDocFileInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedDocVcBloc, SharedDocVcState>(
        builder: (context, state) {
      return state is ShareDocumentsUpdatedState
          ? Card(
              color: AppColors.white,
              surfaceTintColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.small.w),
              ),
              child: SizedBox(
                height: 58.w,
                child: Row(
                  children: [
                    state.documentVcData != null
                        ? state.documentVcData?.fileType == "text/html"
                            ? AppUtils.loadText(state.documentVcData!.tags,
                                fontSize: AppDimensions.extraLarge.sp)
                            : SvgPicture.asset(
                                AppUtils.loadThumbnailBasedOnMimeTime(
                                    state.documentVcData?.fileType),
                                height: 29.w,
                                width: 24.w,
                              )
                        : state.selectedDocs!.length > 1
                            ? SvgPicture.asset(
                                AppUtils.loadThumbnailBasedOnMimeTime(null),
                                height: 29.w,
                                width: 24.w,
                              )
                            : state.selectedDocs![0].fileType == "text/html"
                                ? AppUtils.loadText(state.selectedDocs![0].tags,
                                    fontSize: AppDimensions.extraLarge.sp)
                                : SvgPicture.asset(
                                    AppUtils.loadThumbnailBasedOnMimeTime(
                                        state.selectedDocs![0].fileType),
                                    height: 29.w,
                                    width: 24.w,
                                  ),
                    AppDimensions.medium.horizontalSpace,
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.documentVcData != null
                            ? Expanded(
                                child: state.documentVcData!.name
                                    .titleBoldWithDots(size: 14.sp, maxLine: 1),
                              )
                            : state.selectedDocs!.length > 1
                                ? Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child:
                                          '${state.selectedDocs!.length} ${WalletKeys.files.stringToString}'
                                              .titleBold(size: 14.sp),
                                    ),
                                  )
                                : Expanded(
                                    child: state.selectedDocs![0].name
                                        .titleBoldWithDots(
                                            size: 14.sp, maxLine: 1),
                                  ),
                        AppDimensions.extraExtraSmall.verticalSpace,
                        state.documentVcData != null
                            ? Expanded(
                                child: TagListWidgets(
                                  tags: state.documentVcData!.tags,
                                ),
                              )
                            : state.selectedDocs?.length == 1
                                ? Expanded(
                                    child: TagListWidgets(
                                      tags: state.selectedDocs![0].tags,
                                    ),
                                  )
                                : Container(),
                      ],
                    )),
                  ],
                ).symmetricPadding(
                    vertical: AppDimensions.small.w,
                    horizontal: AppDimensions.medium.w),
              ),
            )
          : Container();
    });
  }
}
