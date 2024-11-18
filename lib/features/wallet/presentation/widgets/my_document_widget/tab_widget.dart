import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../blocs/wallet_bloc/wallet_bloc.dart';

/// A widget that represents a tab interface for navigating between "My Documents" and "My Consents".
class TabWidget extends StatefulWidget {
  final int index; // The currently active tab index

  const TabWidget({super.key, required this.index});

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize the tab index to 0 when the widget is first created
    context.read<WalletDataBloc>().updateWalletTabIndex(index: 0);
  }

  @override
  Widget build(BuildContext context) {
    // Build the tab item based on the current index
    return _buildTabItem(widget.index);
  }

  /// Builds the tab item UI based on the provided [index].
  ///
  /// [index] is the current index of the tab to be displayed.
  Widget _buildTabItem(int index) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.extraSmall), // Apply padding to the container
      decoration: BoxDecoration(
        color: AppColors.white,
        // Set background color of the container
        borderRadius: BorderRadius.circular(AppDimensions.smallXL),
        // Apply border radius to corners
        boxShadow: const [
          BoxShadow(
            color: AppColors.grey100, // Shadow color
            offset: Offset(0, 10), // Offset of the shadow
            blurRadius: 30, // Blur radius for the shadow
          )
        ],
      ),
      child: Row(
        children: [
          // Create a tab button for "My Documents"
          tabButtonWidget(
            index: index,
            label: WalletKeys.myDocuments.stringToString,
            position: 0,
          ),
          // Create a tab button for "My Consents"
          tabButtonWidget(
            index: index,
            label: WalletKeys.myConsents.stringToString,
            position: 1,
          ),
        ],
      ).symmetricPadding(horizontal: AppDimensions.extraSmall.sp), // Apply symmetric padding
    );
  }

  /// Creates a widget for a tab button.
  ///
  /// [index] is the current active tab index.
  /// [label] is the text to display on the button.
  /// [position] is the position of the button in the tab layout.
  Widget tabButtonWidget({
    required int index,
    required String label,
    required int position,
  }) {
    return Expanded(
      // Ensure the button takes up available horizontal space equally
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          // Remove internal padding
          elevation: WidgetStateProperty.all<double>(0),
          // Remove button elevation
          backgroundColor: WidgetStateProperty.all<Color>(
            index == position ? AppColors.primaryColor : Colors.transparent, // Set background color based on active tab
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppDimensions.small)), // Set uniform border radius
            ),
          ),
        ),
        onPressed: () {
          // Update the tab index when the button is pressed
          if (widget.index != position) {
            context.read<WalletDataBloc>().updateWalletTabIndex(index: position);
          }
        },
        child: label.titleBold(
          size: AppDimensions.smallXXL.sp, // Set font size to 14sp
          color: index == position ? AppColors.white : AppColors.grey9898a5, // Set text color based on active tab
        ),
      ),
    );
  }
}
