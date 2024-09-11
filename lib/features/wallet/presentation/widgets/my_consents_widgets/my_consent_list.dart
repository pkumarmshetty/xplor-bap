import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../domain/entities/shared_data_entity.dart';
import '../../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../update_consent_dialog.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/utils.dart';
import '../../../domain/entities/previous_consent_entity.dart';
import '../../blocs/my_consent_bloc/my_consent_bloc.dart';
import '../../blocs/my_consent_bloc/my_consent_event.dart';
import '../../blocs/my_consent_bloc/my_consent_state.dart';
import '../wallet_common_widget.dart';
import 'consent_no_doc_view.dart';

part 'my_consent_list_tile.dart';

part 'my_previous_consent_tile.dart';

/// Widget that displays a list of consents, including active consents and previous consents.
/// It listens to `MyConsentBloc` for state changes and updates the UI accordingly.
class MyConsentList extends StatefulWidget {
  const MyConsentList({
    super.key,
  });

  @override
  State<MyConsentList> createState() => _MyConsentListState();
}

class _MyConsentListState extends State<MyConsentList> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<MyConsentBloc, MyConsentState>(
      listener: (context, state) {
        // No additional actions are required on state change in this widget
      },
      child: BlocBuilder<MyConsentBloc, MyConsentState>(
        builder: (context, state) {
          // Handle state changes
          if (state is MyConsentLoadedState) {
            if (state.myConsents.isEmpty) {
              // If there are no consents, display the ConsentNoDocVcView widget
              return const ConsentNoDocVcView();
            } else {
              // Display a scrollable view containing active and previous consents
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section for active consents
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WalletKeys.activeConsents.stringToString.titleExtraBold(
                          size: AppDimensions.mediumXL.sp,
                          color: AppColors.grey64697a,
                        ),
                      ],
                    ),
                    AppDimensions.medium.verticalSpace,
                    // List of active consents
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.myConsents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: AppDimensions.small,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.consentBorderColor,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.small),
                          ),
                          child: _buildExpandableTile(
                            index,
                            context,
                            state.myConsents[index],
                          ),
                        );
                      },
                    ),
                    AppDimensions.mediumXL.verticalSpace,
                    // Section for previous consents if any
                    if (state.previousConsents.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletKeys.previousConsents.stringToString.titleExtraBold(
                            size: AppDimensions.mediumXL,
                            color: AppColors.grey64697a,
                          ),
                        ],
                      ),
                      AppDimensions.medium.verticalSpace,
                      // List of previous consents
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.previousConsents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: AppDimensions.small,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.consentBorderColor,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(AppDimensions.small),
                            ),
                            child: _buildPreviousConsentsTile(
                              index,
                              context,
                              state.previousConsents[index],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              );
            }
          } else {
            // Placeholder container if bloc state is not yet loaded
            return Container();
          }
        },
      ),
    );
  }
}
