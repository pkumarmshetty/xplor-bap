import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../widgets/add_document_dialog_widget.dart';

class WalletNoDocumentView extends StatefulWidget {
  const WalletNoDocumentView({super.key});

  @override
  State<WalletNoDocumentView> createState() => _WalletNoDocumentViewState();
}

class _WalletNoDocumentViewState extends State<WalletNoDocumentView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(Assets.images.noDocumentsAdded),
        AppDimensions.mediumXL.vSpace(),
        'No Documents Added!'.titleExtraBold(
          color: AppColors.black,
          size: AppDimensions.mediumXL.sp,
        ),
        AppDimensions.small.vSpace(),
        'There is no document added yet.'.titleRegular(size: 14.sp, color: AppColors.black),
        'Please add a document.'.titleRegular(size: 14.sp, color: AppColors.black),
        AppDimensions.smallXL.vSpace(),
        ButtonWidget(
          title: 'Add Document',
          isValid: true,
          onPressed: () => addDocumentDialog(),
        ).symmetricPadding(horizontal: 69.w),
      ],
    );
  }

  void addDocumentDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AddDocumentDialogWidget();
        });
  }
}
