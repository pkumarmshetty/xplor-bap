import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../blocs/apply_course_bloc.dart';

class AddDocumentWidget extends StatefulWidget {
  const AddDocumentWidget({super.key});

  @override
  State<AddDocumentWidget> createState() => _AddDocumentWidgetState();
}

class _AddDocumentWidgetState extends State<AddDocumentWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        String sharedByName = "Scholarship";

        var course = context.read<ApplyCourseBloc>().course!;

        if (course.provider.name.isNotEmpty) {
          sharedByName = course.provider.name;
        } else {
          sharedByName = "Scholarship";
        }

        sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isSharedByScholarship, true);

        sl<SharedPreferencesHelper>().setString(PrefConstKeys.sharedBy, sharedByName);

        Navigator.pushNamed(context, Routes.courseDocument);
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(AppDimensions.smallXL.r)),
        child: Row(
          children: [
            SvgPicture.asset(Assets.images.icAddDoc),
            AppDimensions.medium.w.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SeekerHomeKeys.addDocument.stringToString
                    .titleBold(size: AppDimensions.smallXL.sp, color: AppColors.black282A37),
                AppDimensions.extraSmall.verticalSpace,
                SeekerHomeKeys.chooseFromWallet.stringToString.titleBold(size: 10.sp, color: AppColors.color667091)
              ],
            )
          ],
        ).symmetricPadding(horizontal: AppDimensions.medium.w, vertical: AppDimensions.smallXL.w),
      ).symmetricPadding(horizontal: AppDimensions.medium.w, vertical: AppDimensions.small.w),
    );
  }
}
