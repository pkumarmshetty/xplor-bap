import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/routes/path_routing.dart';
import '../../domain/entities/seeker_entity.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_dimensions.dart';
import 'common_seeker_tile_widget.dart';

/// Widget displaying a list of seekers in a skill tab.
///
/// Allows tapping on each seeker tile to navigate to their dashboard.
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
            return AppDimensions.medium.verticalSpace; // Adds vertical space between items
          },
          itemCount: _seekers.length,
          // Number of seekers to display
          itemBuilder: (context, index) {
            final item = _seekers[index]; // Get the seeker entity for the current index
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.seekerDashboard),
              child: CommonSeekerTileWidget(item: item), // Display the seeker tile widget
            );
          },
        ),
      ],
    );
  }
}

// List of seeker entities to display in the SkillTabWidget
List<SeekerEntity> _seekers = [
  SeekerEntity(
    title: "Shital Sharma",
    subTitle: "Student",
    icon: Assets.images.user, // Example icon for the seeker
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
