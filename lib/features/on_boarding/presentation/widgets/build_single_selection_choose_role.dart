import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../blocs/select_role_bloc/select_role_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/color/color_material_state.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../const/local_storage/pref_const_key.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../blocs/select_role_bloc/select_role_state.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectRoleBloc, SelectRoleState>(
        listener: (context, state) {},
        child: BlocBuilder<SelectRoleBloc, SelectRoleState>(
            builder: (context, state) {
          // Handle state changes
          if (state is SelectRoleLoadedState) {
            return ListView.builder(
              itemCount: state.userRoles.length,
              itemBuilder: (BuildContext context, int index) {
                final role = state.userRoles[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: AppDimensions.small),
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
                          (states) => states
                              .getFillColor(), // Use the extension function
                        ),
                        value: index,
                        groupValue: widget.selectedIndex,
                        onChanged: (value) {
                          widget.onIndexChanged(value as int);
                        },
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            role.imageUrl ?? '',
                            height: 128.w,
                            width: 128.w,
                          ),
                          AppDimensions.medium.hSpace(),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              role.title?.titleBold(
                                      size: 20.sp, color: AppColors.black100) ??
                                  const SizedBox(),
                              AppDimensions.smallXL.vSpace(),
                              role.description?.titleRegular(
                                      size: 12.sp, color: AppColors.black100) ??
                                  const SizedBox(),
                            ],
                          ))
                        ],
                      ),
                      onTap: () {
                        if (kDebugMode) {
                          print("Role ID: ${role.id}");
                        }
                        SharedPreferencesHelper()
                            .setString(PrefConstKeys.roleID, role.id ?? '');
                        setState(() {
                          widget.onIndexChanged(index);
                        });
                      },
                    ),
                  ),
                ).symmetricPadding(horizontal: AppDimensions.medium);
              },
            );
          } else {
            return const SizedBox();
          }
        }));
  }

  /// Extension functions
  Color getFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return AppColors.primaryColor; // Selected color
    }
    return AppColors.hintColor; // Unselected color
  }
}
