import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/widgets/update_consent_dialog.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

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
        listener: (context, state) {},
        child: BlocBuilder<MyConsentBloc, MyConsentState>(builder: (context, state) {
          // Handle state changes
          if (state is MyConsentLoadedState) {
            if (state.myConsents.isEmpty) {
              return const ConsentNoDocVcView();
            } else {
              return SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WalletKeys.activeConsents.stringToString.titleExtraBold(
                        size: 20.sp,
                        color: AppColors.grey64697a,
                      ),
                    ],
                  ),
                  AppDimensions.medium.vSpace(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.myConsents.length,
                    // Number of expandable tiles
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.consentBorderColor,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.small),
                          ),
                          child: _buildExpandableTile(index, context, state.myConsents[index]));
                    },
                  ),
                  AppDimensions.mediumXL.vSpace(),
                  if (state.previousConsents.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WalletKeys.previousConsents.stringToString.titleExtraBold(
                          size: 20.sp,
                          color: AppColors.grey64697a,
                        ),
                      ],
                    ),
                  if (state.previousConsents.isNotEmpty) AppDimensions.medium.vSpace(),
                  if (state.previousConsents.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.previousConsents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.consentBorderColor,
                                width: 1.w,
                              ),
                              borderRadius: BorderRadius.circular(AppDimensions.small),
                            ),
                            child: _buildPreviousConsentsTile(index, context, state.previousConsents[index]));
                      },
                    )
                ]),
              );
            }
          } else {
            return Container();
          }
        }));
  }
}
