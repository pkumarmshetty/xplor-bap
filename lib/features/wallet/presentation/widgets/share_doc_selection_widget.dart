import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';

class ShareDocSelectionWidget extends StatefulWidget {
  const ShareDocSelectionWidget({
    super.key,
    required this.onTap,
    required this.validity,
    required this.title,
  });

  final VoidCallback onTap;
  final Validity validity;
  final String title;

  @override
  State<ShareDocSelectionWidget> createState() => _ShareDocSelectionWidgetState();
}

class _ShareDocSelectionWidgetState extends State<ShareDocSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedDocVcBloc, SharedDocVcState>(builder: (context, state) {
      return state is ShareDocumentsUpdatedState
          ? InkWell(
              splashColor: Colors.transparent,
              onTap: widget.onTap,
              child: Card(
                margin: EdgeInsets.only(bottom: 10.w),
                surfaceTintColor: AppColors.white.withOpacity(0.62),
                color: AppColors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.medium.w),
                  side: BorderSide(
                      color: state.validity == widget.validity
                          ? AppColors.primaryColor.withOpacity(0.26)
                          : AppColors.white,
                      width: state.validity == widget.validity ? 2 : 1), // Border color and width
                ),
                child: Row(
                  children: [
                    state.validity == widget.validity
                        ? SvgPicture.asset(
                            Assets.images.icRadioSelected,
                            height: AppDimensions.mediumXL.w,
                            width: AppDimensions.mediumXL.w,
                          )
                        : Icon(
                            Icons.circle_outlined,
                            size: AppDimensions.mediumXL.w,
                            color: AppColors.greyBorderC1,
                          ),
                    SizedBox(width: AppDimensions.mediumXL.w),
                    Expanded(
                        child: widget.title.stringToString
                            .titleRegular(size: AppDimensions.smallXXL.sp, color: AppColors.grey64697a)),
                  ],
                ).paddingAll(padding: AppDimensions.medium.w),
              ))
          : Container();
    });
  }
}
