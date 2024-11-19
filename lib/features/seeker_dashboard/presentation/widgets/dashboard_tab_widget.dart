import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../on_boarding/domain/entities/categories_entity.dart';
import '../../domain/entities/courses_entity.dart';
import 'recent_applications_widget.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/courses_label.dart';
import '../../../multi_lang/domain/mappers/seeker_dashboard/seeker_dashboard_keys.dart';
import 'jobs_widget.dart';

/// A widget that displays the dashboard tab content for a seeker.
///
/// The [DashBoardTabWidget] includes sections for recent applications,
/// a category selector, and recommended jobs. It provides a structured
/// overview of various elements on the dashboard.
class DashBoardTabWidget extends StatefulWidget {
  const DashBoardTabWidget({super.key});

  @override
  State<DashBoardTabWidget> createState() => _DashBoardTabWidgetState();
}

class _DashBoardTabWidgetState extends State<DashBoardTabWidget> {
  // Holds the currently selected category label.
  String? _selectedLabel;

  @override
  initState() {
    super.initState();
    // Initialize with the first category label.
    _selectedLabel = courseLabels[0].category;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Displays the header for the recent applications section.
        _headerTitle(
          title: SeekerDashboardKeys.recentApplications.stringToString,
        ),
        // Adds vertical space.
        10.verticalSpace,
        // Displays a horizontal list of recent applications.
        AspectRatio(
          aspectRatio: AppDimensions.extraSmall,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return AppDimensions.smallXL.w.horizontalSpace;
            },
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return const RecentApplicationsWidget();
            },
          ),
        ),
        // Adds vertical space.
        AppDimensions.mediumXL.verticalSpace,
        // Displays the header for the category section.
        _headerTitle(
          title: SeekerDashboardKeys.category.stringToString,
        ),
        // Adds vertical space.
        AppDimensions.smallXL.verticalSpace,
        // Displays a horizontal list of category labels.
        AspectRatio(
          aspectRatio: 13,
          child: ListView.separated(
            separatorBuilder: (context, index) => 9.w.horizontalSpace,
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
                      _selectedLabel = null; // Deselect if already selected.
                    } else {
                      _selectedLabel = selectedLabel;
                    }
                  });
                },
              );
            },
          ),
        ),
        // Adds vertical space.
        AppDimensions.mediumXL.verticalSpace,
        // Displays a list of recommended jobs.
        _recommendedJobs(),
        // Adds vertical space.
        AppDimensions.mediumXL.verticalSpace,
        // Displays another list of recommended jobs (could be replaced or duplicated based on the design).
        _recommendedJobs(),
      ],
    );
  }
}

/// Creates a section displaying recommended jobs.
Widget _recommendedJobs() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Displays the header for the recommended jobs section.
      SeekerDashboardKeys.recommendedJobs.stringToString.titleBold(size: AppDimensions.medium.sp),
      // Adds vertical space.
      AppDimensions.small.verticalSpace,
      // Displays a horizontal list of recommended jobs.
      AspectRatio(
        aspectRatio: 1.9,
        child: ListView.separated(
          key: UniqueKey(),
          separatorBuilder: (context, index) {
            return AppDimensions.smallXL.w.horizontalSpace;
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

/// Creates a header row with a title and a "view all" option.
Widget _headerTitle({required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Displays the title of the section.
      title.titleBold(size: AppDimensions.medium.sp),
      // Displays a "view all" button with a link to view all items.
      SeekerDashboardKeys.viewAll.stringToString.titleBold(
        color: AppColors.primaryColor,
        size: AppDimensions.smallXXL.sp,
      ),
    ],
  );
}

/// List of course widgets to be displayed as recommended jobs.
List<CoursesEntity> getJobsWidgets = [
  CoursesEntity(
    image: Assets.images.dummyCourseImage.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
  CoursesEntity(
    image: Assets.images.dummyCourseImage.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
  CoursesEntity(
    image: Assets.images.dummyCourseImage.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
  CoursesEntity(
    image: Assets.images.dummyCourseImage.path,
    title: "Infosys",
    subTitle: "UI/UX Designer",
    price: "₹10,000/-",
  ),
];

/// List of category labels to be used in the category selection section.
List<CategoryEntity> courseLabels = [
  CategoryEntity(id: "1", category: "Engineering", value: "Engineering"),
  CategoryEntity(id: "2", category: "Commerce", value: "Commerce"),
  CategoryEntity(id: "3", category: "Electronics", value: "Electronics"),
  CategoryEntity(id: "4", category: "Culinary", value: "Culinary"),
  CategoryEntity(id: "5", category: "Science", value: "Science"),
];
