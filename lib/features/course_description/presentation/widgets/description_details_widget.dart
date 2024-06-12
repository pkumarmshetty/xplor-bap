import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/course_description/domain/entity/item_tag_data.dart';
import 'package:xplor/features/multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import 'package:xplor/utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/space.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../domain/entity/services_items.dart';

class DescriptionDetailsWidget extends StatelessWidget {
  const DescriptionDetailsWidget({super.key, required this.course});

  final CourseDetailsDataEntity course;

  /*String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeekerHomeKeys.about.stringToString.titleBold(size: 16.sp),
        //_buildTabItem(_currentIndex),
        AppDimensions.smallXL.vSpace(),

        ReadMoreText(
          course.descriptor.longDesc,
          trimMode: TrimMode.Line,
          trimLines: 10,
          style: GoogleFonts.manrope(
            color: AppColors.grey6469,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          colorClickableText: AppColors.primaryColor,
          trimCollapsedText: '   ${SeekerHomeKeys.readMore.stringToString}',
          trimExpandedText: '   ${SeekerHomeKeys.readLess.stringToString}',
          moreStyle: const TextStyle(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
          lessStyle: const TextStyle(color: AppColors.primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        AppDimensions.mediumXXL.vSpace(),
        instructorWidget(),

        if (course.tagData != null && course.tagData!.list.isNotEmpty) _listViewData(course.tagData!.list),
        AppDimensions.mediumXL.vSpace(),
        /* BlocBuilder<ApplyCourseBloc, ApplyCourseState>(
            builder: (context, state) {
          return ButtonWidget(
            onPressed: () async {
              if (state is ApplyFormLoaderState) {
                return;
              }
              final bool isLoggedIn = await AppUtils.checkToken();
              if (!context.mounted) return;
              _goToNext(context, isLoggedIn);
            },
            title: state is ApplyFormLoaderState
                ? SeekerHomeKeys.plsWait.stringToString
                : SeekerHomeKeys.enrollNow.stringToString,
            isValid: context.read<ApplyCourseBloc>().isEnabledOnSelect,
          );
        }),*/
        AppDimensions.mediumXL.vSpace(),
      ],
    ).singleSidePadding(bottom: AppDimensions.xxlLarge);
  }

  _listViewData(List<ItemTagList> list) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              list[index].descriptor!.name.titleBold(size: 16.sp),
              AppDimensions.extraSmall.vSpace(),
              list[index].value.titleRegular(color: AppColors.grey6469, size: 14.sp),
              AppDimensions.medium.vSpace(),
            ],
          );
        });
  }

  Column instructorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SeekerHomeKeys.instructor.stringToString.titleBold(size: AppDimensions.medium.sp),
        AppDimensions.smallXL.vSpace(),
        Row(
          children: [
            course.provider.images.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppDimensions.smallXL),
                    ),
                    child: CachedNetworkImage(
                        height: 48.w,
                        width: 48.w,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        imageUrl: course.provider.images[0],
                        placeholder: (context, url) => const Center(
                              child: LoadingAnimation(),
                            ),
                        errorWidget: (context, url, error) => SvgPicture.asset(
                              Assets.images.icAvtarMale,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ).paddingAll(padding: AppDimensions.small)),
                  )
                : SvgPicture.asset(
                    Assets.images.icAvtarMale,
                    height: 48.w,
                    width: 48.w,
                  ),
            AppDimensions.smallXL.hSpace(),
            Expanded(
              child: course.provider.name.titleBold(size: AppDimensions.smallXXL.sp),
            )
            /*Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                course.provider.name.titleBold(size: AppDimensions.smallXXL.sp),
                if (course.provider.shortDesc.isNotEmpty)
                  (course.provider.shortDesc).titleRegular(
                    maxLines: 5,
                    size: AppDimensions.smallXXL.sp,
                    color: AppColors.tabsUnselectedTextColor,
                  ),
              ],
            ))*/
          ],
        ),
      ],
    );
  }
}
