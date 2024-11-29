// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../domain/entities/domains_entity.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/extensions/font_style/font_styles.dart';
// import '../../../../utils/utils.dart';
// import '../../../../utils/app_dimensions.dart';
//
// class DomainWidget extends StatelessWidget {
//   final DomainData domainData;
//   final Function(bool) onSelect;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         splashColor: Colors.transparent,
//         onTap: () {
//           // Handle onTap action here
//           onSelect(!domainData.isSelected);
//         },
//         child: Card(
//           color: AppColors.white,
//           margin: EdgeInsets.only(bottom: AppDimensions.smallXL.w),
//           surfaceTintColor: Colors.white.withOpacity(0.62),
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppDimensions.medium.w),
//             side: BorderSide(
//                 color: domainData.isSelected ? AppColors.blueBorder1581.withOpacity(0.26) : AppColors.white,
//                 width: domainData.isSelected ? 2 : 1), // Border color and width
//           ),
//           child: Row(
//             children: [
//               /*CachedNetworkImage(
//                 height: 60.w,
//                 width: 60.w,
//                 filterQuality: FilterQuality.high,
//                 imageUrl: domainData.icon,
//                 placeholder: (context, url) => const Center(
//                   child: LoadingAnimation(),
//                 ),
//                 errorWidget: (context, url, error) => GestureDetector(
//                   onTap: () {},
//                   child: const Icon(Icons.error),
//                 ),
//               ),*/
//               SvgPicture.network(
//                 domainData.icon,
//                 width: 60.w,
//                 height: 60.w,
//                 fit: BoxFit.cover,
//                 placeholderBuilder: (BuildContext context) => Center(
//                     child: SizedBox(
//                   width: 60.w,
//                   height: 60.w,
//                   child: const Padding(
//                       padding: EdgeInsets.all(AppDimensions.mediumXL),
//                       child: CircularProgressIndicator(
//                         color: AppColors.primaryColor,
//                         strokeWidth: 3.0,
//                       )),
//                 )),
//               ),
//               SizedBox(width: AppDimensions.mediumXL.w), // Add spacing between leading and title
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     domainData.title.titleBold(size: 16.sp, color: AppColors.black100),
//                     AppDimensions.extraSmall.verticalSpace,
//                     domainData.description.titleRegular(size: 12.sp, color: AppColors.black100),
//                   ],
//                 ),
//               ),
//               domainData.isSelected
//                   ? SvgPicture.asset(
//                       Assets.images.icSelected,
//                       height: AppDimensions.mediumXL.w,
//                       width: AppDimensions.mediumXL.w,
//                     )
//                   : Container(),
//             ],
//           ).symmetricPadding(horizontal: AppDimensions.smallXL.w, vertical: AppDimensions.smallXL.w),
//         ));
//   }
//
//   const DomainWidget({
//     super.key,
//     required this.domainData,
//     required this.onSelect,
//   });
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../domain/entities/domains_entity.dart';
// import '../../../../gen/assets.gen.dart';
// import '../../../../utils/app_colors.dart';
// import '../../../../utils/extensions/font_style/font_styles.dart';
// import '../../../../utils/utils.dart';
// import '../../../../utils/app_dimensions.dart';
//
// class DomainWidget extends StatelessWidget {
//   final DomainData domainData;
//   final Function(bool) onSelect;
//
//   const DomainWidget({
//     super.key,
//     required this.domainData,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       splashColor: Colors.transparent,
//       onTap: () {
//         // Handle onTap action here
//         onSelect(!domainData.isSelected);
//       },
//       child: Card(
//         color: AppColors.white,
//         margin: EdgeInsets.only(bottom: AppDimensions.smallXL.w),
//         surfaceTintColor: Colors.white.withOpacity(0.62),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(AppDimensions.medium.w),
//           side: BorderSide(
//             color: domainData.isSelected
//                 ? AppColors.blueBorder1581.withOpacity(0.26)
//                 : AppColors.white,
//             width: domainData.isSelected ? 2 : 1,
//           ), // Border color and width
//         ),
//         child: Row(
//           children: [
//             SvgPicture.network(
//               domainData.icon,
//               width: 60.w,
//               height: 60.w,
//               fit: BoxFit.cover,
//               placeholderBuilder: (BuildContext context) => Center(
//                 child: SizedBox(
//                   width: 60.w,
//                   height: 60.w,
//                   child: Padding(
//                     padding: EdgeInsets.all(AppDimensions.mediumXL),
//                     child: Icon(
//                       Icons.account_circle, // Common icon added here
//                       size: 40.w,
//                       color: AppColors.grey, // Icon color
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: AppDimensions.mediumXL.w), // Add spacing between leading and title
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   domainData.title.titleBold(size: 16.sp, color: AppColors.black100),
//                   AppDimensions.extraSmall.verticalSpace,
//                   domainData.description.titleRegular(size: 12.sp, color: AppColors.black100),
//                 ],
//               ),
//             ),
//             domainData.isSelected
//                 ? SvgPicture.asset(
//               Assets.images.icSelected,
//               height: AppDimensions.mediumXL.w,
//               width: AppDimensions.mediumXL.w,
//             )
//                 : Container(),
//           ],
//         ).symmetricPadding(horizontal: AppDimensions.smallXL.w, vertical: AppDimensions.smallXL.w),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/domains_entity.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/app_dimensions.dart';

class DomainWidget extends StatelessWidget {
  final DomainData domainData;
  final Function(bool) onSelect;

  const DomainWidget({
    super.key,
    required this.domainData,
    required this.onSelect,
  });

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
            color: domainData.isSelected
                ? AppColors.blueBorder1581.withOpacity(0.26)
                : AppColors.white,
            width: domainData.isSelected ? 2 : 1,
          ), // Border color and width
        ),
        child: Row(
          children: [
            // Display different icon based on domainData.title
            _getIconForDomain(domainData.title),
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
      ),
    );
  }

  // Function to get different icons based on domainData.title
  Widget _getIconForDomain(String title) {
    switch (title) {
      case "Skill":
        return Icon(
          Icons.school, // Icon for Skill
          size: 60.w,
          color: AppColors.primaryColor,
        );
      case "Job":
        return Icon(
          Icons.work, // Icon for Job
          size: 40.w,
          color: AppColors.primaryColor,
        );
      case "Scholarship":
        return Icon(
          Icons.card_giftcard, // Icon for Scholarship
          size: 40.w,
          color: AppColors.primaryColor,
        );
      default:
        return Icon(
          Icons.help_outline, // Default icon if title is not recognized
          size: 40.w,
          color: AppColors.grey,
        );
    }
  }
}

