import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
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
                    if (kDebugMode) {
                      print("Role ID: ${role.id} TYPE: ${role.type}");
                    }
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
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.w),
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
                                  height: 20.w,
                                  width: 20.w,
                                ),
                              )
                            : SizedBox(
                                height: 20.w,
                                width: 20.w,
                              ),
                        /*SvgPicture.asset(
                          role.imageUrl ?? '',
                          height: 147.w,
                          width: 147.w,
                        )*/
                        CachedNetworkImage(
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
                        ),
                        10.verticalSpace,
                        role.title?.titleExtraBold(color: AppColors.black3939, size: 20.sp) ?? const SizedBox(),
                        5.verticalSpace,
                        role.description
                                ?.titleRegular(color: AppColors.grey6469, size: 12.sp, align: TextAlign.center) ??
                            const SizedBox(),
                      ],
                    ).paddingAll(padding: 20.w),
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
  Color getFillColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return AppColors.primaryColor; // Selected color
    }
    return AppColors.hintColor; // Unselected color
  }
}
