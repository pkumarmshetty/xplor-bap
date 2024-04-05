import 'package:flutter/material.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_button.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_single_selection_choose_role.dart';
import 'package:xplor/features/on_boarding/presentation/widgets/build_welcome.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';

/// Import statements related to routing and services
import '../../../../../config/routes/path_routing.dart';
import '../../../../../config/services/app_services.dart';
import '../../../../../utils/app_dimensions.dart';

/// Class for the ChooseRoleView widget
class ChooseRoleView extends StatefulWidget {
  const ChooseRoleView({super.key});

  @override
  State<ChooseRoleView> createState() => _ChooseRoleViewState();
}

/// State class for the ChooseRoleView widget
class _ChooseRoleViewState extends State<ChooseRoleView> {
  int selectedIndex = -1;

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainContent(context),
          AppDimensions.large.vSpace(),
          Expanded(
              child: SingleSelectionChooseRole(
            selectedIndex: selectedIndex,
            onIndexChanged: setSelectedIndex,
          )),
          _bottomViewContent(context)
        ],
      )),
    );
  }

  /// Method to build the main content of the view
  Widget _buildMainContent(BuildContext context) {
    return const WelcomeContentWidget(
            title: 'Choose your role', subTitle: 'Please select your role.')
        .symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }

  /// Method to build the bottom content of the view
  Widget _bottomViewContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonWidget(
          title: 'Continue',
          isValid: selectedIndex != -1,
          onPressed: () {
            Navigator.pushNamed(
              AppServices.navState.currentContext!,
              Routes.kyc,
            );
          },
        ),
        AppDimensions.mediumXL.vSpace(),
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }
}
