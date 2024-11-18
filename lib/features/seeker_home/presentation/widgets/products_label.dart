import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/utils/app_dimensions.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/padding.dart';

/// Products label
class ProductsLabel extends StatelessWidget {
  const ProductsLabel({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 77.w,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLightColor.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            placeholder: (context, url) => SvgPicture.asset(
                  Assets.images.productThumnail,
                ).paddingAll(padding: AppDimensions.extraSmall),
            errorWidget: (context, url, error) => SvgPicture.asset(
                  Assets.images.productThumnail,
                ).paddingAll(padding: AppDimensions.extraSmall)),
      ),
    ).symmetricPadding(vertical: AppDimensions.extraSmall.w, horizontal: AppDimensions.extraSmall.w);
  }
}
