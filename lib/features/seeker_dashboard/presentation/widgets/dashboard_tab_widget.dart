import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xplor/features/on_boarding/domain/entities/categories_entity.dart';
import 'package:xplor/features/seeker_dashboard/domain/entities/courses_entity.dart';
import 'package:xplor/features/seeker_dashboard/presentation/widgets/recent_applications_widget.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/courses_label.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'jobs_widget.dart';

class DashBoardTabWidget extends StatefulWidget {
  const DashBoardTabWidget({super.key});

  @override
  State<DashBoardTabWidget> createState() => _DashBoardTabWidgetState();
}

class _DashBoardTabWidgetState extends State<DashBoardTabWidget> {
  String? _selectedLabel;

  @override
  initState() {
    super.initState();
    _selectedLabel = courseLabels[0].category;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerTitle(title: SeekerDashboardKeys.recentApplications.stringToString),
        10.vSpace(),
        AspectRatio(
          aspectRatio: 4,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return AppDimensions.smallXL.hSpace();
            },
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return const RecentApplicationsWidget();
            },
          ),
        ),
        AppDimensions.mediumXL.vSpace(),
        _headerTitle(title: SeekerDashboardKeys.category.stringToString),
        AppDimensions.smallXL.vSpace(),
        AspectRatio(
          aspectRatio: 13,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return 9.hSpace();
            },
            scrollDirection: Axis.horizontal,
            itemCount: courseLabels.length,
            itemBuilder: (context, index) {
              final label = courseLabels[index].category;
              final value = courseLabels[index].value;
              final isSelected = _selectedLabel == value;

              return CoursesLabel(
                label: label.toString(),
                value: value.toString(),
                isSelected: isSelected,
                onChanged: (selectedLabel) {
                  setState(() {
                    if (_selectedLabel == selectedLabel) {
                      _selectedLabel = null; // Deselect if already selected
                    } else {
                      _selectedLabel = selectedLabel;
                    }
                  });
                },
              );
            },
          ),
        ),
        AppDimensions.mediumXL.vSpace(),
        _recommendedJobs(),
        AppDimensions.mediumXL.vSpace(),
        _recommendedJobs(),
      ],
    );
  }
}

_recommendedJobs() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SeekerDashboardKeys.recommendedJobs.stringToString.titleBold(size: AppDimensions.medium.sp),
      AppDimensions.small.vSpace(),
      AspectRatio(
        aspectRatio: 1.9,
        child: ListView.separated(
          key: UniqueKey(),
          separatorBuilder: (context, index) {
            return AppDimensions.smallXL.hSpace();
          },
          scrollDirection: Axis.horizontal,
          itemCount: getJobsWidgets.length,
          itemBuilder: (context, index) {
            return JobsWidget(course: getJobsWidgets[index]);
          },
        ),
      ),
    ],
  );
}

_headerTitle({required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      title.titleBold(size: AppDimensions.medium.sp),
      SeekerDashboardKeys.viewAll.stringToString.titleBold(
        color: AppColors.primaryColor,
        size: AppDimensions.smallXXL.sp,
      ),
    ],
  );
}

List<CoursesEntity> getJobsWidgets = [
  CoursesEntity(
    image: Assets.images.dummyCourseImagePng.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
  CoursesEntity(
    image: Assets.images.dummyCourseImagePng.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
  CoursesEntity(
    image: Assets.images.dummyCourseImagePng.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
  CoursesEntity(
    image: Assets.images.dummyCourseImagePng.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
];

List<CategoryEntity> courseLabels = [
  CategoryEntity(id: "1", category: "Engineering", value: "Engineering"),
  CategoryEntity(id: "2", category: "Commerce", value: "Commerce"),
  CategoryEntity(id: "3", category: "Electronics", value: "Electronics"),
  CategoryEntity(id: "4", category: "Culinary", value: "Culinary"),
  CategoryEntity(id: "5", category: "Science", value: "Science"),
];
