import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../const/app_state.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/space.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../blocs/select_role_bloc/select_role_bloc.dart';
import '../../blocs/select_role_bloc/select_role_event.dart';
import '../../blocs/select_role_bloc/select_role_state.dart'; // Import SelectRoleState
import '../../widgets/build_button.dart';
import '../../widgets/build_single_selection_choose_role.dart';
import '../../widgets/build_welcome.dart';

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

  /// Method to get the user roles
  @override
  void initState() {
    super.initState();
    context
        .read<SelectRoleBloc>()
        .add(const GetUserRolesEvent()); // Use SelectRoleBloc
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (bool val) {
        AppUtils.showAlertDialog(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<SelectRoleBloc, SelectRoleState>(
            listener: (context, state) {
              // Handle state changes
              if (state is SelectRoleErrorState) {
                // Show error message
                AppUtils.showSnackBar(context, state.errorMessage);
              } else if (state is SelectRoleNavigationState) {
                // Navigate to KYC screen
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.kyc, (routes) => false);
              }
            },
            child: BlocBuilder<SelectRoleBloc, SelectRoleState>(
              builder: (context, state) {
                // Handle state changes
                if (state is SelectRoleLoadingState &&
                    state.status == AppPageStatus.loading) {
                  // Show loading animation
                  return const LoadingAnimation();
                } else {
                  if (state is SelectRoleLoadedState &&
                      state.userRoles.isNotEmpty) {
                    // Show main content
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMainContent(context),
                        AppDimensions.large.vSpace(),
                        Expanded(
                          child: SingleSelectionChooseRole(
                            selectedIndex: selectedIndex,
                            onIndexChanged: setSelectedIndex,
                          ),
                        ),
                        _bottomViewContent(context)
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Method to build the main content of the view
  Widget _buildMainContent(BuildContext context) {
    return const WelcomeContentWidget(
      title: 'Choose your role',
      subTitle: 'Please select your role.',
    ).symmetricPadding(
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
            context
                .read<SelectRoleBloc>()
                .add(AssignRoleEvent()); // Use SelectRoleBloc
          },
        ),
        AppDimensions.mediumXL.vSpace(),
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }
}
