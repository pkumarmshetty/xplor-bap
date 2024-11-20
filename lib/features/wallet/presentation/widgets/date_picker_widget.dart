import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';

class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    super.key,
    required this.onDateTimeChanged,
    this.selectedDate,
    this.onOkPressed,
    this.mode = CupertinoDatePickerMode.date,
    this.showActionButtons = true,
    DateTime? minimumDate
  }) : minimumDate = minimumDate ?? DateTime.now().add(const Duration(days: 4));

  final DateTime? selectedDate;
  final Function(DateTime) onDateTimeChanged;
  final Function()? onOkPressed;

  final CupertinoDatePickerMode mode;

  final bool showActionButtons;

  final DateTime minimumDate;

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppDimensions.mediumXL.verticalSpace,
        WalletKeys.selectDate.stringToString.titleBold(size: 18.sp),
        AppDimensions.smallXL.verticalSpace,
        // CupertinoDatePicker
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            initialDateTime: widget.selectedDate ?? DateTime.now().add(const Duration(days: 5)),
            minimumDate: widget.minimumDate,
            maximumDate: DateTime.now().add(const Duration(days: 365)),
            // Limit to one year from today
            mode: widget.mode,
            onDateTimeChanged: widget.onDateTimeChanged,
          ),
        ),
        // OK and Cancel buttons
        widget.showActionButtons ? Row(
          children: [
            Expanded(
              child: ButtonWidget(
                isFilled: false,
                radius: AppDimensions.small,
                buttonBackgroundColor: AppColors.white,
                buttonForegroundColor: AppColors.white,
                customText: WalletKeys.cancel.stringToString.titleBold(size: 14, color: AppColors.primaryColor),
                isValid: true,
                onPressed: () => Navigator.pop(context),
              ).symmetricPadding(horizontal: 10),
            ),
            Expanded(
              child: ButtonWidget(
                title: WalletKeys.ok.stringToString,
                radius: AppDimensions.small,
                isValid: true,
                onPressed: widget.onOkPressed,
              ).symmetricPadding(horizontal: 10),
            ),
          ],
        ) : AppDimensions.smallXL.verticalSpace,
        AppDimensions.smallXL.verticalSpace,
      ],
    );
  }
}
