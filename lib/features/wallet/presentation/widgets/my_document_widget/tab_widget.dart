import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/widgets/build_button.dart';
import '../../blocs/wallet_bloc/wallet_bloc.dart';

class TabWidget extends StatelessWidget {
  final int index;

  const TabWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.f8f9fa,
      child: Row(
        children: [
          Expanded(
            child: ButtonWidget(
              shadowColor: AppColors.f8f9fa,
              shape: index == 1
                  ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0), // Adjust the radius as needed
                        bottomLeft: Radius.circular(8.0), // Adjust the radius as needed
                      ),
                    )
                  : null,
              fontSize: 12.sp,
              buttonBackgroundColor: index == 0 ? AppColors.primaryColor : AppColors.f8f9fa,
              customText:
                  'My Documents'.titleSemiBold(size: 14.sp, color: index == 0 ? AppColors.white : AppColors.black),
              isValid: true,
              onPressed: () {
                if (index != 0) {
                  context.read<WalletDataBloc>().updateWalletTabIndex(index: 0);
                }
              },
            ),
          ),
          Expanded(
            child: ButtonWidget(
              shadowColor: AppColors.f8f9fa,
              shape: index == 0
                  ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8.0),
                        // Adjust the radius as needed
                        topRight: Radius.circular(8.0), // Adjust the radius as needed
                      ),
                    )
                  : null,
              fontSize: 12.sp,
              buttonBackgroundColor: index == 1 ? AppColors.primaryColor : AppColors.f8f9fa,
              customText:
                  'My Consents'.titleRegular(size: 14.sp, color: index == 1 ? AppColors.white : AppColors.black),
              isValid: true,
              onPressed: () {
                if (index != 1) {
                  context.read<WalletDataBloc>().updateWalletTabIndex(index: 1);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
