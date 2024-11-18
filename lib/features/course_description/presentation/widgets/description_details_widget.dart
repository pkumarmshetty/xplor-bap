import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../domain/entity/item_tag_data.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
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
        SeekerHomeKeys.about.stringToString
            .titleBold(size: AppDimensions.medium.sp),
        //_buildTabItem(_currentIndex),
        AppDimensions.smallXL.verticalSpace,

        ReadMoreText(
          course.descriptor.longDesc,
          trimMode: TrimMode.Line,
          trimLines: 10,
          style: GoogleFonts.manrope(
            color: AppColors.grey6469,
            fontSize: AppDimensions.smallXXL.sp.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          colorClickableText: AppColors.primaryColor,
          trimCollapsedText: '   ${SeekerHomeKeys.readMore.stringToString}',
          trimExpandedText: '   ${SeekerHomeKeys.readLess.stringToString}',
          moreStyle: TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppDimensions.smallXXL.sp,
              fontWeight: FontWeight.w500),
          lessStyle: TextStyle(
              color: AppColors.primaryColor,
              fontSize: AppDimensions.smallXXL.sp,
              fontWeight: FontWeight.w500),
        ),
        AppDimensions.mediumXXL.verticalSpace,
        instructorWidget(),
        if (course.tagData != null && course.tagData!.list.isNotEmpty)
          _listViewData(course.tagData!.list),
        AppDimensions.mediumXL.verticalSpace,
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
        AppDimensions.mediumXL.verticalSpace,
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
              (list[index].descriptor?.name ?? list[index].name)
                  .titleBold(size: AppDimensions.medium.sp),
              AppDimensions.extraSmall.verticalSpace,
              setTagListValue(list[index].value).titleRegular(
                  color: AppColors.grey6469, size: AppDimensions.smallXXL.sp),
              AppDimensions.medium.verticalSpace,
            ],
          );
        });
  }

  String setTagListValue(String value) {
    var isValid = isTimeStamp(value);
    if (isValid) {
      return AppUtils.convertDateFormatToAnother(
          "yyyy-MM-ddTHH:mm:ss.SSSSSS+00:00", "dd MMMM yyyy", value);
    } else {
      return value;
    }
  }

  bool isTimeStamp(String timestamp) {
    final RegExp regExp = RegExp(
      r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})$',
    );

    return regExp.hasMatch(timestamp);
  }

  Column instructorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SeekerHomeKeys.instructor.stringToString
            .titleBold(size: AppDimensions.medium.sp),
        AppDimensions.smallXL.verticalSpace,
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
                        placeholder: (context, url) => SvgPicture.asset(
                              Assets.images.icAvtarMale,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ).paddingAll(padding: AppDimensions.small),
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
            AppDimensions.smallXL.w.horizontalSpace,
            Expanded(
              child: course.provider.name
                  .titleBold(size: AppDimensions.smallXXL.sp),
            ),
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
