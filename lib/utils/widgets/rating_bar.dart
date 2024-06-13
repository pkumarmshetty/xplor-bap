import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rating_bar_updated/rating_bar_updated.dart';

import '../app_colors.dart';

class RatingBarWidget extends StatelessWidget {
  final double rating;

  final bool readable;
  final ValueChanged<double>? onChanged;
  final Color filledColor;

  const RatingBarWidget(
      {super.key,
      this.rating = 0.0,
      this.onChanged,
      this.readable = false,
      this.filledColor = AppColors.yellowfab});

  @override
  Widget build(BuildContext context) {
    return readable
        ? RatingBar.readOnly(
            initialRating: rating,
            size: 24.w,
            isHalfAllowed: true,
            aligns: Alignment.centerLeft,
            halfFilledIcon: Icons.star_half,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            filledColor: filledColor,
            emptyColor: AppColors.grey64697a,
            halfFilledColor: filledColor,
          )
        : RatingBar(
            initialRating: rating,
            onRatingChanged: onChanged,
            halfFilledIcon: Icons.star_half,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            isHalfAllowed: true,
            aligns: Alignment.center,
            filledColor: filledColor,
            emptyColor: AppColors.grey64697a,
            halfFilledColor: filledColor,
            size: 36.w,
          );
  }
}
