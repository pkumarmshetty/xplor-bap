import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/circluar_button.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../blocs/select_role_bloc/select_role_bloc.dart';
import '../../blocs/select_role_bloc/select_role_event.dart';
import '../../blocs/select_role_bloc/select_role_state.dart';
import '../../widgets/build_single_selection_choose_role.dart';

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
    context.read<SelectRoleBloc>().add(const GetUserRolesEvent()); // Use SelectRoleBloc
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SelectRoleBloc, SelectRoleState>(
        listener: (context, state) {
          // Handle state changes
          if (state is SelectRoleErrorState) {
            // Show error message
            AppUtils.showSnackBar(context, state.errorMessage);
          } else if (state is SelectRoleFetchedState && state.status == RoleState.saved) {
            var prefs = sl<SharedPreferencesHelper>();
            var role = prefs.getString(PrefConstKeys.selectedRole);
            if (role == PrefConstKeys.seekerKey) {
              sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedRole, PrefConstKeys.seekerKey);
              Navigator.pushNamed(context, Routes.chooseDomain);
            } else {
              sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedRole, PrefConstKeys.agentKey);
              Navigator.pushNamed(context, Routes.login);
            }
            sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.role}Done', true);
          }
        },
        child: AppBackgroundDecoration(
          child: BlocBuilder<SelectRoleBloc, SelectRoleState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  (state is SelectRoleFetchedState)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTopHeader(
                              title: OnBoardingKeys.chooseRole.stringToString,
                              onBackButtonPressed: () => Navigator.of(context).pop(),
                            ),
                            AppDimensions.large.vSpace(),
                            Expanded(
                              child: SingleSelectionChooseRole(
                                selectedIndex: selectedIndex,
                                onIndexChanged: setSelectedIndex,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  (state is SelectRoleFetchedState && state.userRoles.isNotEmpty)
                      ? _bottomViewContent(context)
                      : const SizedBox(),
                  if (state is SelectRoleFetchedState && state.status == RoleState.loading) const LoadingAnimation(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Method to build the bottom content of the view
  Widget _bottomViewContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircularButton(
          isValid: selectedIndex != -1,
          onPressed: () {
            context.read<SelectRoleBloc>().add(const AssignRoleEvent()); // Use SelectRoleBloc
          },
          title: OnBoardingKeys.next.stringToString,
        ).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.large.w)
      ],
    );
  }
}
