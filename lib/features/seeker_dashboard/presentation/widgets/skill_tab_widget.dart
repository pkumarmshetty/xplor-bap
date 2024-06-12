import 'package:flutter/material.dart';
import 'package:xplor/config/routes/path_routing.dart';
import 'package:xplor/features/seeker_dashboard/domain/entities/seeker_entity.dart';
import 'package:xplor/utils/extensions/space.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import 'common_seeker_tile_widget.dart';

class SkillTabWidget extends StatelessWidget {
  const SkillTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return AppDimensions.medium.vSpace();
            },
            itemCount: _seekers.length,
            itemBuilder: (context, index) {
              final item = _seekers[index];
              return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, Routes.seekerDashboard),
                  child: CommonSeekerTileWidget(item: item));
            }),
      ],
    );
  }
}

List<SeekerEntity> _seekers = [
  SeekerEntity(
    title: "Shital Sharma",
    subTitle: "Student",
    icon: Assets.images.user,
  ),
  SeekerEntity(
    title: "Shital Sharma",
    subTitle: "Student",
    icon: Assets.images.user,
  ),
  SeekerEntity(
    title: "Shital Sharma",
    subTitle: "Student",
    icon: Assets.images.user,
  ),
  SeekerEntity(
    title: "Shital Sharma",
    subTitle: "Student",
    icon: Assets.images.user,
  ),
];
