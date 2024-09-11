import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../blocs/select_role_bloc/select_role_bloc.dart';
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
  State<SingleSelectionChooseRole> createState() => _SingleSelectionChooseRoleState();
}

/// _SingleSelectionChooseRoleState class
class _SingleSelectionChooseRoleState extends State<SingleSelectionChooseRole> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectRoleBloc, SelectRoleState>(
        listener: (context, state) {},
        child: BlocBuilder<SelectRoleBloc, SelectRoleState>(builder: (context, state) {
          // Handle state changes
          if (state is SelectRoleFetchedState) {
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 120.w),
              itemCount: state.userRoles.length,
              itemBuilder: (BuildContext context, int index) {
                final role = state.userRoles[index];
                return GestureDetector(
                  onTap: () {
                    AppUtils.printLogs("Role ID: ${role.id} TYPE: ${role.type}");
                    sl<SharedPreferencesHelper>().setString(PrefConstKeys.roleID, role.id ?? '');
                    sl<SharedPreferencesHelper>().setString(PrefConstKeys.selectedRole, role.type ?? '');
                    setState(() {
                      widget.onIndexChanged(index);
                    });
                  },
                  child: Card(
                    color: AppColors.white,
                    margin: const EdgeInsets.only(bottom: AppDimensions.medium),
                    surfaceTintColor: Colors.white.withOpacity(0.62),
                    elevation: AppDimensions.extraSmall,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.medium.w),
                      side: BorderSide(
                          color: widget.selectedIndex == index
                              ? AppColors.blueBorder1581.withOpacity(0.26)
                              : AppColors.white,
                          width: widget.selectedIndex == index ? 2 : 1), // Border color and width
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.selectedIndex == index
                            ? Align(
                                alignment: Alignment.topRight,
                                child: SvgPicture.asset(
                                  Assets.images.icCheckSelection,
                                  height: AppDimensions.mediumXL.w,
                                  width: AppDimensions.mediumXL.w,
                                ),
                              )
                            : SizedBox(
                                height: AppDimensions.mediumXL.w,
                                width: AppDimensions.mediumXL.w,
                              ),

                        /// Commented for future reference
                        /*CachedNetworkImage(
                          width: 147.w,
                          height: 147.w,
                          imageUrl: role.imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),*/
                        SvgPicture.network(
                          role.imageUrl ?? '',
                          width: 147.0,
                          height: 147.0,
                          fit: BoxFit.cover,
                          placeholderBuilder: (BuildContext context) => const Center(
                              child: SizedBox(
                            width: 147.0,
                            height: 147.0,
                            child: Padding(
                                padding: EdgeInsets.all(60),
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                  strokeWidth: 3.0,
                                )),
                          )),
                        ),
                        AppDimensions.smallXL.verticalSpace,
                        role.title?.titleExtraBold(color: AppColors.black3939, size: 20.sp) ?? const SizedBox(),
                        AppDimensions.extraSmall.verticalSpace,
                        role.description
                                ?.titleRegular(color: AppColors.grey6469, size: 12.sp, align: TextAlign.center) ??
                            const SizedBox(),
                      ],
                    ).paddingAll(padding: AppDimensions.mediumXL.w),
                  ).symmetricPadding(horizontal: AppDimensions.medium),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        }));
  }

  /// Extension functions
  Color getFillColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return AppColors.primaryColor; // Selected color
    }
    return AppColors.hintColor; // Unselected color
  }
}
