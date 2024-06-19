import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/on_boarding/domain/entities/domains_entity.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

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
          margin: EdgeInsets.only(bottom: 10.w),
          surfaceTintColor: Colors.white.withOpacity(0.62),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
            side: BorderSide(
                color: domainData.isSelected
                    ? AppColors.blueBorder1581.withOpacity(0.26)
                    : AppColors.white,
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
                placeholderBuilder: (BuildContext context) => const Center(
                    child: SizedBox(
                  width: 60.0,
                  height: 60.0,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        strokeWidth: 3.0,
                      )),
                )),
              ),
              SizedBox(width: 20.w), // Add spacing between leading and title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    domainData.title
                        .titleBold(size: 16.sp, color: AppColors.black100),
                    5.verticalSpace,
                    domainData.description
                        .titleRegular(size: 12.sp, color: AppColors.black100),
                  ],
                ),
              ),
              domainData.isSelected
                  ? SvgPicture.asset(
                      Assets.images.icSelected,
                      height: 20.w,
                      width: 20.w,
                    )
                  : Container(),
            ],
          ).symmetricPadding(horizontal: 10.w, vertical: 10.w),
        ));
  }

  const DomainWidget({
    super.key,
    required this.domainData,
    required this.onSelect,
  });
}
