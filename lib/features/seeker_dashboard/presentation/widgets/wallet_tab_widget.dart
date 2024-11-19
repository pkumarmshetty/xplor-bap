import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';

/// Widget displaying a list of documents as cards.
///
/// Each card represents a document with an icon, title, and verification status.
class WalletTagWidget extends StatefulWidget {
  const WalletTagWidget({super.key});

  @override
  State<WalletTagWidget> createState() => _WalletTagWidgetState();
}

class _WalletTagWidgetState extends State<WalletTagWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // Aspect ratio of 1 to maintain square shape
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return documents[index]; // Build each document card
        },
        separatorBuilder: (BuildContext context, int index) {
          return 10.verticalSpace; // Add vertical space between cards
        },
        itemCount: documents.length, // Number of document cards to display
      ),
    );
  }

  // List of document card widgets
  List<DocumentsCardWidget> documents = [
    const DocumentsCardWidget(title: "Addhaar Card"),
    const DocumentsCardWidget(title: "Addhaar Card"),
  ];
}

/// Widget representing a document card with an icon, title, and verification status.
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
        // Background color of the card
        borderRadius: BorderRadius.circular(AppDimensions.medium),
        // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: AppColors.searchShadowColor, // Shadow color
            offset: Offset(0, 1), // Offset of the shadow
            blurRadius: 1, // Blur radius of the shadow
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
              Assets.images.pdf, // Icon representing the document type
              height: 44.sp, // Size of the icon
            ),
            AppDimensions.medium.w.horizontalSpace,
            // Horizontal space between icon and title
            Expanded(
              child: title.titleBold(
                // Title of the document card
                size: AppDimensions.medium.sp, // Font size of the title
                color: AppColors.blackMedium, // Color of the title text
              ),
            ),
            SvgPicture.asset(
              Assets.images.icVerified, // Verification status icon
              height: AppDimensions.large.sp, // Size of the verification status icon
            ),
          ],
        ).symmetricPadding(
          horizontal: AppDimensions.medium.sp,
          // Horizontal padding inside the card
          vertical: AppDimensions.smallXL.sp, // Vertical padding inside the card
        ),
      ),
    );
  }
}
