import 'package:flutter/material.dart';

///

/// Additional imports
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/on_boarding/domain/entities/select_wallet_type_entity.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/color/color_material_state.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';

/// SingleSelectionChooseRole class
class SingleSelectionChooseRole extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const SingleSelectionChooseRole({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  State<SingleSelectionChooseRole> createState() =>
      _SingleSelectionChooseRoleState();
}

/// _SingleSelectionChooseRoleState class
class _SingleSelectionChooseRoleState extends State<SingleSelectionChooseRole> {
  List<WalletSelectionEntity> items = [
    WalletSelectionEntity(
        icon: 'assets/images/i_am_agent.png',
        title: 'I am an Agent',
        message:
            'An intermediary who helps in the distribution of the service'),
    WalletSelectionEntity(
        icon: 'assets/images/i_am_seeker.png',
        title: 'I am a Seeker',
        message: 'Individual who is seeking for the service.'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
          decoration: BoxDecoration(
            color: widget.selectedIndex == index
                ? Colors.transparent
                : Colors.white,
            border: Border.all(
              color: widget.selectedIndex == index
                  ? AppColors.primaryColor
                  : AppColors.hintColor,
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
                  (states) =>
                      states.getFillColor(), // Use the extension function
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
                    height: 128.w,
                    width: 128.w,
                  ),
                  AppDimensions.medium.hSpace(),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.title
                          .titleBold(size: 20.sp, color: AppColors.black100),
                      AppDimensions.smallXL.vSpace(),
                      item.message
                          .titleRegular(size: 12.sp, color: AppColors.black100)
                    ],
                  ))
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

  Color getFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return AppColors.primaryColor; // Selected color
    }
    return AppColors.hintColor; // Unselected color
  }
}
