import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/entities/domains_entity.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/app_dimensions.dart';

class DomainWidget extends StatelessWidget {
  final DomainData domainData;
  final Function(bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          // Handle onTap action here
          onSelect(!domainData.isSelected);
        },
        child: Card(
          color: AppColors.white,
          margin: EdgeInsets.only(bottom: AppDimensions.smallXL.w),
          surfaceTintColor: Colors.white.withOpacity(0.62),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.medium.w),
            side: BorderSide(
                color: domainData.isSelected ? AppColors.blueBorder1581.withOpacity(0.26) : AppColors.white,
                width: domainData.isSelected ? 2 : 1), // Border color and width
          ),
          child: Row(
            children: [
              /*CachedNetworkImage(
                height: 60.w,
                width: 60.w,
                filterQuality: FilterQuality.high,
                imageUrl: domainData.icon,
                placeholder: (context, url) => const Center(
                  child: LoadingAnimation(),
                ),
                errorWidget: (context, url, error) => GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.error),
                ),
              ),*/
              SvgPicture.network(
                domainData.icon,
                width: 60.w,
                height: 60.w,
                fit: BoxFit.cover,
                placeholderBuilder: (BuildContext context) => Center(
                    child: SizedBox(
                  width: 60.w,
                  height: 60.w,
                  child: const Padding(
                      padding: EdgeInsets.all(AppDimensions.mediumXL),
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 3.0,
                      )),
                )),
              ),
              SizedBox(width: AppDimensions.mediumXL.w), // Add spacing between leading and title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    domainData.title.titleBold(size: 16.sp, color: AppColors.black100),
                    AppDimensions.extraSmall.verticalSpace,
                    domainData.description.titleRegular(size: 12.sp, color: AppColors.black100),
                  ],
                ),
              ),
              domainData.isSelected
                  ? SvgPicture.asset(
                      Assets.images.icSelected,
                      height: AppDimensions.mediumXL.w,
                      width: AppDimensions.mediumXL.w,
                    )
                  : Container(),
            ],
          ).symmetricPadding(horizontal: AppDimensions.smallXL.w, vertical: AppDimensions.smallXL.w),
        ));
  }

  const DomainWidget({
    super.key,
    required this.domainData,
    required this.onSelect,
  });
}
