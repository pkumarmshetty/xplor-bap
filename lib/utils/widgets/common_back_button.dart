import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../extensions/padding.dart';
import '../../gen/assets.gen.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

class CommonBackButton extends StatelessWidget {
  /// Callback function for OK button press
  final VoidCallback onBackPressed;

  /// Constructor for CustomConfirmationDialog
  const CommonBackButton({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBackPressed,
      child: Container(
        height: 38.w,
        width: 38.w,
        margin: const EdgeInsets.symmetric(horizontal: AppDimensions.medium, vertical: AppDimensions.mediumXL),
        decoration: BoxDecoration(
          color: AppColors.blueWith10Opacity, // Set your desired background color
          borderRadius: BorderRadius.circular(9), // Set your desired border radius
        ),
        child: SvgPicture.asset(height: AppDimensions.medium.w, width: AppDimensions.medium.w, Assets.images.icBack)
            .paddingAll(padding: AppDimensions.smallXL),
      ),
    );
  }
}
