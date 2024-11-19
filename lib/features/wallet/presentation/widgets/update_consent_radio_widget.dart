import 'package:flutter/material.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/extensions/string_to_string.dart';

class UpdateConsentRadioWidget extends StatelessWidget {
  const UpdateConsentRadioWidget(
      {super.key, required this.title, required this.groupValue, required this.onChanged, required this.value});

  final String title;
  final int groupValue;
  final Function(int?) onChanged;
  final int value;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      contentPadding: EdgeInsets.zero,
      title: Text(title.stringToString),
      visualDensity: VisualDensity.compact,
      dense: true,
      activeColor: AppColors.blue1E88E5,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    ).singleSidePadding(left: 10);
  }
}
