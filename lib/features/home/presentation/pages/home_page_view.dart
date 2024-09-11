import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../bloc/home_bloc.dart';
import '../widgets/dashboard_header_widget.dart';
import '../../../multi_lang/domain/mappers/home/home_keys.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../widgets/overview_tab.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../widgets/dashboard_app_bar_widget.dart';
import '../widgets/seekers_tab.dart';

/// Main view for the HomePage, displaying the user's dashboard.
///
/// This view includes various tabs for different sections like Overview, Seekers,
/// and Earnings. It also handles state changes using `BlocBuilder` for the `HomeBloc`.
class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _currentIndex = 0; // Index for the currently selected tab

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const HomeUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable popping the current route
      onPopInvokedWithResult: (val, result) {
        AppUtils.showAlertDialog(
            context, false); // Show alert dialog on pop attempt
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              (state is HomeUserDataState)
                  ? CustomScrollView(
                      slivers: [
                        const DashBoardAppBarWidget(), // Custom App Bar
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DashboardHeaderWidget(
                                  userDataEntity: state.userData),
                              // Header with user data
                              AppDimensions.medium.verticalSpace,
                              _buildTabItem(_currentIndex),
                              // Build tab items
                              AppDimensions.mediumXL.verticalSpace,
                              tabWidget(_currentIndex),
                              // Display content of the selected tab
                            ],
                          ).symmetricPadding(
                              horizontal: AppDimensions.medium.sp),
                        ),
                      ],
                    )
                  : Container(),
              // Empty container if user data state is not loaded
              if (state is HomeUserDataLoadingState) const LoadingAnimation()
              // Display loading animation if data is loading
            ],
          );
        },
      ),
    );
  }

  /// Builds the tab item container with the available tabs.
  ///
  /// [index] - Index of the currently selected tab.
  Widget _buildTabItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dashboardTabBackgroundColor.withOpacity(0.3),
        // Background color with opacity
        border: Border.all(color: AppColors.checkBoxDisableColor),
        // Border color
        borderRadius:
            BorderRadius.circular(AppDimensions.smallXL), // Rounded corners
      ),
      child: Row(
        children: [
          tabButtonWidget(
            index: index,
            label: HomeKeys.overview.stringToString, // Label for Overview tab
            position: 0,
          ),
          tabButtonWidget(
            index: index,
            label: HomeKeys.seekers.stringToString, // Label for Seekers tab
            position: 1,
          ),
          tabButtonWidget(
            index: index,
            label: HomeKeys.earnings.stringToString, // Label for Earnings tab
            position: 2,
          ),
        ],
      ).symmetricPadding(
          horizontal:
              AppDimensions.extraSmall.sp), // Padding between tab buttons
    );
  }

  /// Creates a tab button widget.
  ///
  /// [index] - Index of the currently selected tab.
  /// [label] - Text label for the tab.
  /// [position] - Position index of the tab.
  Widget tabButtonWidget({
    required int index,
    required String label,
    required int position,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          // No padding
          elevation: WidgetStateProperty.all<double>(0),
          // No elevation
          backgroundColor: WidgetStateProperty.all<Color>(
              index == position ? AppColors.white : Colors.transparent),
          // Background color change on selection
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: index == position
                  ? const BorderSide(
                      width: 1,
                      color: AppColors.tabsSelectedColor,
                    )
                  : const BorderSide(color: Colors.transparent),
              // Border change on selection
              borderRadius: const BorderRadius.all(
                Radius.circular(AppDimensions.small), // Rounded corners
              ),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = position; // Update the selected tab index
          });
        },
        child: label.titleBold(
          size: AppDimensions.smallXXL.sp,
          color: index == position
              ? AppColors.black
              : AppColors.grey9898a5, // Text color change on selection
        ),
      ),
    );
  }

  /// Returns the widget for the selected tab.
  ///
  /// [index] - Index of the currently selected tab.
  Widget tabWidget(int index) {
    switch (index) {
      case 0:
        return const OverviewTab(); // Overview tab content
      case 1:
        return const SeekersTab(); // Seekers tab content
      case 2:
        return const SeekersTab(); // Earnings tab content (placeholder)
      default:
        return Container(); // Default to an empty container
    }
  }
}
