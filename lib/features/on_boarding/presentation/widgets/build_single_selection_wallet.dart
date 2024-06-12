import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/e_auth_providers_entity.dart';

/// Widget for selecting a single wallet option
class SingleSelectionWallet extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;
  final EAuthProviderEntity entity;

  const SingleSelectionWallet({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.entity,
  });

  @override
  State<SingleSelectionWallet> createState() => _SingleSelectionWalletState();
}

class _SingleSelectionWalletState extends State<SingleSelectionWallet> {
  /*List<WalletSelectionEntity> items = [
    WalletSelectionEntity(
      icon: Assets.images.digilocker.path,
      title: OnBoardingKeys.digilocker.stringToString,
      message: OnBoardingKeys.continueWithDigilocker.stringToString,
    ),
  ];*/

  List<EAuthProviderEntity> items = [];

  @override
  void initState() {
    items.clear();
    if (!sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.appForBelem)) {
      widget.entity.title = OnBoardingKeys.digilocker.stringToString;
      widget.entity.subTitle = OnBoardingKeys.continueWithDigilocker.stringToString;
      widget.entity.iconLink = Assets.images.digilocker.path;
    }
    items.add(widget.entity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return Material(
          elevation: AppDimensions.extraSmall, // Set the elevation for drop shadow
          shadowColor: Colors.grey.withOpacity(0.3), // Set the shadow color
          borderRadius: BorderRadius.circular(AppDimensions.medium),
          child: InkWell(
            child: Container(
              // margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
              decoration: BoxDecoration(
                color: widget.selectedIndex == index ? Colors.transparent : Colors.white,
                border: Border.all(
                  color:
                      widget.selectedIndex == index ? AppColors.primaryColor.withOpacity(0.26) : AppColors.greye8e8e8,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.medium),
              ),
              child: GestureDetector(
                onTap: () {
                  sl<SharedPreferencesHelper>().setString(PrefConstKeys.kycRedirectUrl, item.redirectUrl);
                  widget.onIndexChanged(index);
                },
                child: Card(
                  elevation: 0,
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  child: Row(
                    children: [
                      sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.appForBelem)
                          ? CachedNetworkImage(
                              height: 60.w,
                              width: 60.w,
                              imageUrl: item.iconLink,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 30.0,
                                  height: 30.0,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Image.asset(
                              item.iconLink,
                              height: 60.w,
                              width: 60.w,
                            ),
                      AppDimensions.medium.hSpace(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            item.title.titleBold(
                              size: 16.sp,
                              color: AppColors.blackMedium,
                            ),
                            AppDimensions.extraSmall.vSpace(),
                            item.title.titleRegular(
                              size: 12.sp,
                              color: AppColors.blackMedium,
                            ),
                          ],
                        ),
                      ),
                      if (widget.selectedIndex == index)
                        SvgPicture.asset(
                          width: 20.w,
                          height: 20.w,
                          Assets.images.icCheckSelection,
                        ),
                    ],
                  ).paddingAll(padding: AppDimensions.small),
                ),
              ),
            ),
          ),
        ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.small);
      },
    );
  }
}
