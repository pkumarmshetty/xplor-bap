import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

class WalletTagWidget extends StatefulWidget {
  const WalletTagWidget({super.key});

  @override
  State<WalletTagWidget> createState() => _WalletTagWidgetState();
}

class _WalletTagWidgetState extends State<WalletTagWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return documents[index];
          },
          separatorBuilder: (BuildContext context, int index) {
            return 10.vSpace();
          },
          itemCount: documents.length),
    );
  }

  List<DocumentsCardWidget> documents = [
    const DocumentsCardWidget(title: "Addhaar Card"),
    const DocumentsCardWidget(title: "Addhaar Card"),
  ];
}

class DocumentsCardWidget extends StatelessWidget {
  const DocumentsCardWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.medium),
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadowColor, // Shadow color
            offset: Offset(0, 1), // Offset
            blurRadius: 1, // Blur radius
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        surfaceTintColor: AppColors.white,
        color: AppColors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.images.pdf,
              height: 44.sp,
            ),
            AppDimensions.medium.hSpace(),
            Expanded(
              child: title.titleBold(
                size: AppDimensions.medium.sp,
                color: AppColors.blackMedium,
              ),
            ),
            SvgPicture.asset(
              Assets.images.icVerified,
              height: AppDimensions.large.sp,
            ),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.medium.sp,
          vertical: AppDimensions.smallXL.sp,
        ),
      ),
    );
  }
}
