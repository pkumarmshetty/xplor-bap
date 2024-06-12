import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/profile/profile_keys.dart';
import 'package:xplor/features/my_orders/presentation/blocs/course_rating_bloc/course_ratings_bloc.dart';
import 'package:xplor/features/my_orders/presentation/blocs/my_orders_bloc/my_orders_bloc.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/build_button.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../blocs/my_orders_bloc/my_orders_event.dart';

class CourseRatingWidget extends StatefulWidget {
  const CourseRatingWidget({super.key});

  @override
  State<CourseRatingWidget> createState() => _CourseRatingWidgetState();
  static bool isBottomSheetVisible = false;

  static void showRatingsBottomSheet(BuildContext context) {
    isBottomSheetVisible = true;
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CourseRatingWidget();
      },
    ).whenComplete(() {
      isBottomSheetVisible = false;
      context.read<CourseRatingsBloc>().add(RatingsResetEvent());
    });
  }

  static void showThanksForFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ProfileKeys.thanksForFeedback.stringToString.titleExtraBold(
                  color: AppColors.black, size: 24.sp, align: TextAlign.center),
              AppDimensions.medium.verticalSpace,
              ProfileKeys.gladEnjoyingApp.stringToString.titleRegular(
                  color: AppColors.grey9098A3,
                  size: 16.sp,
                  align: TextAlign.center),
              AppDimensions.mediumXXL.verticalSpace,
              ButtonWidget(
                title: ProfileKeys.okay.stringToString,
                isValid: true,
                onPressed: () {
                  Navigator.pop(context);
                  // if (states is ApplyFormLoaderState) {
                  //   return;
                  // }
                  // context.read<CourseRatingsBloc>().add(const RatingsSubmitEvent(orderId:,ratings: ,feedback: ));
                },
              ),
              AppDimensions.medium.verticalSpace
            ],
          ).paddingAll(padding: 20.w),
        );
      },
    );
  }
}

class _CourseRatingWidgetState extends State<CourseRatingWidget> {
  TextEditingController feedbackController = TextEditingController();

  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseRatingsBloc, CourseRatingsState>(
      listener: (context, state) {
        if (state is RatingsSubmittedSuccessState) {
          if (CourseRatingWidget.isBottomSheetVisible) {
            Navigator.pop(context);
          }
          CourseRatingWidget.showThanksForFeedbackDialog(context);
          context
              .read<MyOrdersBloc>()
              .add(const MyOrdersCompletedEvent(isFirstTime: true));
        }
      },
      child: BlocBuilder<CourseRatingsBloc, CourseRatingsState>(
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height / 2 + 50.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileKeys.experienceSoFar.stringToString
                            .titleBold(
                                color: AppColors.black,
                                size: 24.sp,
                                align: TextAlign.center)
                            .symmetricPadding(horizontal: 20.w),
                        AppDimensions.small.verticalSpace,
                        ProfileKeys.loveToKnow.stringToString.titleRegular(
                            color: AppColors.grey9098A3, size: 16.sp),
                        AppDimensions.medium.verticalSpace,
                        RatingBar(
                          initialRating: state is CourseRatingsUpdatedState
                              ? state.ratings
                              : 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 36.w,
                          ratingWidget: RatingWidget(
                            full: SvgPicture.asset(Assets.images.rating,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.yellowfab,
                                  BlendMode.srcIn,
                                )),
                            half: SvgPicture.asset(Assets.images.ratingHalf,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.yellowfab,
                                  BlendMode.srcIn,
                                )),
                            empty: SvgPicture.asset(
                              Assets.images.ratingHollow,
                            ),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 10.w),
                          onRatingUpdate: (selectedRating) {
                            rating = selectedRating;
                            context.read<CourseRatingsBloc>().add(
                                RatingsUpdateEvent(
                                    ratings: rating,
                                    feedback: feedbackController.text));
                          },
                        ),
                        AppDimensions.large.verticalSpace,
                        Container(
                          height: 20 * 8,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.black.withOpacity(0.1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(6.w)),
                          // Calculate the height based on the number of lines
                          child: TextField(
                            onChanged: (text) {
                              context.read<CourseRatingsBloc>().add(
                                  RatingsUpdateEvent(
                                      ratings: rating, feedback: text));
                              feedbackController.text = text;
                            },
                            style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.countryCodeColor),
                            maxLines: 5,
                            controller: feedbackController,
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                int newLines = newValue.text.split('\n').length;
                                if (newLines > 5) {
                                  return oldValue;
                                } else {
                                  return newValue;
                                }
                              }),
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: null,
                              enabledBorder: null,
                              hintText: ProfileKeys.startTyping.stringToString,
                            ),
                          ).symmetricPadding(horizontal: 10, vertical: 5),
                        ),
                        AppDimensions.mediumXXL.verticalSpace,
                        ButtonWidget(
                          title: ProfileKeys.send.stringToString,
                          isValid: (state is CourseRatingsUpdatedState &&
                              state.feedback.isNotEmpty),
                          onPressed: () {
                            // if (states is ApplyFormLoaderState) {
                            //   return;
                            // }
                            context.read<CourseRatingsBloc>().add(
                                RatingsSubmitEvent(
                                    ratings: rating,
                                    feedback: feedbackController.text));
                          },
                        ),
                        AppDimensions.large.verticalSpace
                      ],
                    ).paddingAll(padding: 20),
                  ),
                ),
                (state is CourseRatingsUpdatedState && state.isLoading)
                    ? const Center(child: LoadingAnimation())
                    : Container()
              ],
            ),
          ).singleSidePadding(bottom: MediaQuery.of(context).viewInsets.bottom);
        },
      ),
    );
  }
}
