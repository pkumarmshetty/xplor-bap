import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/on_boarding/domain/entities/select_wallet_type_entity.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/color/color_material_state.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

import '../../../../gen/assets.gen.dart';

/// Widget for selecting a single wallet option
class SingleSelectionWallet extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const SingleSelectionWallet({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<SingleSelectionWallet> createState() => _SingleSelectionWalletState();
}

class _SingleSelectionWalletState extends State<SingleSelectionWallet> {
  List<WalletSelectionEntity> items = [
    WalletSelectionEntity(
      icon: Assets.images.digilocker.path,
      title: 'Digilocker',
      message: 'Continue with Digilocker',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return Container(
          /// Container styling
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
          decoration: BoxDecoration(
            color: widget.selectedIndex == index ? Colors.transparent : Colors.white,
            border: Border.all(
              color: widget.selectedIndex == index ? AppColors.primaryColor : AppColors.hintColor,
              width: 2.w,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.smallXL),
          ),
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Radio(
                visualDensity: const VisualDensity(horizontal: -4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: AppColors.primaryColor,
                fillColor: MaterialStateProperty.resolveWith(
                  (states) => states.getFillColor(), // Use the extension function
                ),
                value: index,
                groupValue: widget.selectedIndex,
                onChanged: (value) {
                  widget.onIndexChanged(value as int);
                },
              ),
              title: Row(
                children: [
                  Image.asset(
                    item.icon,
                    height: 48.w,
                    width: 48.w,
                  ),
                  AppDimensions.medium.hSpace(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title styling
                      item.title.titleBold(size: 16.sp, color: AppColors.countryCodeColor),
                      AppDimensions.extraSmall.vSpace(),

                      /// Message styling
                      item.message.titleRegular(size: 14.sp, color: AppColors.countryCodeColor)
                    ],
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  widget.onIndexChanged(index);
                });
              },
            ),
          ),
        ).symmetricPadding(horizontal: AppDimensions.medium);
      },
    );
  }
}
