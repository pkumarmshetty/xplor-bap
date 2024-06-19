import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../blocs/wallet_bloc/wallet_bloc.dart';

class TabWidget extends StatefulWidget {
  final int index;

  const TabWidget({super.key, required this.index});

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  @override
  void initState() {
    super.initState();
    context.read<WalletDataBloc>().updateWalletTabIndex(index: 0);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTabItem(widget.index);
  }

  Widget _buildTabItem(int index) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          // Set border radius for all corners
          boxShadow: const [
            BoxShadow(
              color: AppColors.grey100,
              offset: Offset(0, 10),
              blurRadius: 30,
            )
          ]),
      child: Row(
        children: [
          tabButtonWidget(
              index: index,
              label: WalletKeys.myDocuments.stringToString,
              position: 0),
          tabButtonWidget(
              index: index,
              label: WalletKeys.myConsents.stringToString,
              position: 1),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp),
    );
  }

  Widget tabButtonWidget({
    required int index,
    required String label,
    required int position,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          // minimumSize: Size(0, 0),
          elevation: WidgetStateProperty.all<double>(0),
          backgroundColor: WidgetStateProperty.all<Color>(
              index == position ? AppColors.primaryColor : Colors.transparent),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ), // To remove the default radius.
            ),
          ),
        ),
        onPressed: () {
          if (widget.index != 0) {
            context.read<WalletDataBloc>().updateWalletTabIndex(index: 0);
          }
          if (widget.index != 1) {
            context.read<WalletDataBloc>().updateWalletTabIndex(index: 1);
          }
        },
        child: label.titleBold(
            size: 14.sp,
            color: index == position ? AppColors.white : AppColors.grey9898a5),
      ),
    );
  }
}
