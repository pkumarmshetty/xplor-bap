import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import '../../config/routes/path_routing.dart';
import '../../features/on_boarding/domain/entities/user_data_entity.dart';
import '../extensions/font_style/font_styles.dart';
import '../extensions/space.dart';

import '../../gen/assets.gen.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.role,
    required this.editOnProfile,
    required this.imageUrl,
    this.userData,
  });

  final String name;
  final String role;
  final String? imageUrl;
  final UserDataEntity? userData;
  final bool editOnProfile;

  @override
  Widget build(BuildContext context) {
    String avtar = userData?.kyc?.gender == 'NA'
        ? Assets.images.icAvtarMale
        : userData?.kyc?.gender == "M"
            ? Assets.images.icAvtarMale
            : Assets.images.icAvtarFemale;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          Stack(children: [
            Container(
              width: 82.w,
              height: 82.w,
              margin: const EdgeInsets.only(right: AppDimensions.smallXXL),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryLightColor.withOpacity(0.25),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? "",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SvgPicture.asset(
                    avtar,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) => SvgPicture.asset(
                    avtar,
                    fit: BoxFit.fill,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            if (editOnProfile)
              Positioned(
                  bottom: 0,
                  right: 15,
                  child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.editProfile, arguments: userData),
                      child: SvgPicture.asset(Assets.images.editIcon)))
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              name.titleSemiBold(size: AppDimensions.mediumXL.sp),
              AppDimensions.extraExtraSmall.vSpace(),
              //role.titleSemiBold(color: AppColors.grey9898a5, size: AppDimensions.smallXXL.sp),
              //AppDimensions.extraSmall.vSpace(),
              if (editOnProfile)
                Row(
                  children: [
                    SvgPicture.asset(Assets.images.rating),
                    6.hSpace(),
                    '0'.titleSemiBold(size: AppDimensions.smallXL.sp, color: AppColors.primaryColor),
                    AppDimensions.extraSmall.hSpace(),
                    ProfileKeys.ratingSeekers.stringToString
                        .titleSemiBold(size: AppDimensions.smallXL.sp, color: AppColors.tabsUnselectedTextColor),
                  ],
                )
            ],
          ),
        ]),
        if (!editOnProfile)
          GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.editProfile, arguments: userData),
              child: SvgPicture.asset(Assets.images.editLarge)),
      ],
    );
  }
}
