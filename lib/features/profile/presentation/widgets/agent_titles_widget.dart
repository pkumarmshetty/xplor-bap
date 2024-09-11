import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/profile_skill_tile_widget.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../bloc/agent_profile_bloc/agent_profile_bloc.dart';

class AgentTilesWidget extends StatelessWidget {
  const AgentTilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgentProfileBloc, AgentProfileState>(builder: (context, state) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ProfileSkillTileWidget(
                    title: ProfileKeys.skilling.stringToString,
                    icon: Assets.images.skilling,
                    value: '0',
                    backgroundColor: AppColors.lightBlueProfileTiles),
              ),
              AppDimensions.smallXL.w.horizontalSpace,
              Expanded(
                child: ProfileSkillTileWidget(
                    title: ProfileKeys.retail.stringToString,
                    icon: Assets.images.retail,
                    value: '${state.userData?.count.retail}',
                    backgroundColor: AppColors.lightPurple),
              ),
            ],
          ),
          AppDimensions.smallXL.verticalSpace,
          Row(
            children: [
              Expanded(
                child: ProfileSkillTileWidget(
                    title: ProfileKeys.agriculture.stringToString,
                    icon: Assets.images.agriculture,
                    value: '0',
                    backgroundColor: AppColors.lightOrange),
              ),
              AppDimensions.smallXL.w.horizontalSpace,
              Expanded(
                child: ProfileSkillTileWidget(
                    title: ProfileKeys.job.stringToString,
                    icon: Assets.images.job,
                    value: '${state.userData?.count.job}',
                    backgroundColor: AppColors.lightGreen.withOpacity(0.25)),
              ),
            ],
          ),
        ],
      );
    });
  }
}
