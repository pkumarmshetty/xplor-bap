import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../blocs/course_rating_bloc/course_ratings_bloc.dart';
import '../blocs/my_orders_bloc/my_orders_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../../utils/widgets/rating_bar.dart';
import '../blocs/my_orders_bloc/my_orders_event.dart';

/// A widget for displaying and submitting course ratings.
class CourseRatingWidget extends StatefulWidget {
  const CourseRatingWidget({super.key});

  @override
  State<CourseRatingWidget> createState() => _CourseRatingWidgetState();

  // Indicates whether the bottom sheet is currently visible
  static bool isBottomSheetVisible = false;

  /// Displays the ratings bottom sheet.
  static void showRatingsBottomSheet(BuildContext context) {
    isBottomSheetVisible = true;
    var courseRatingBloc = context.read<CourseRatingsBloc>();
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const CourseRatingWidget();
      },
    ).whenComplete(() {
      isBottomSheetVisible = false;
      // Resets the ratings state after closing the bottom sheet
      courseRatingBloc.add(const RatingsResetEvent());
    });
  }

  /// Displays a thank you dialog after submitting feedback.
  static void showThanksForFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.all(AppDimensions.mediumXL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.mediumXL),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ProfileKeys.thanksForFeedback.stringToString.titleExtraBold(
                  color: AppColors.black,
                  size: AppDimensions.large.sp,
                  align: TextAlign.center),
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
                },
              ),
              AppDimensions.medium.verticalSpace
            ],
          ).paddingAll(padding: AppDimensions.mediumXL.w),
        );
      },
    );
  }
}

/// The state for [CourseRatingWidget].
class _CourseRatingWidgetState extends State<CourseRatingWidget> {
  // Controller for the feedback text field
  TextEditingController feedbackController = TextEditingController();

  // Variable to store the rating value
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    // Listens for changes in the course ratings state
    return BlocListener<CourseRatingsBloc, CourseRatingsState>(
      listener: (context, state) {
        if (state is RatingsSubmittedSuccessState) {
          if (CourseRatingWidget.isBottomSheetVisible) {
            Navigator.pop(context);
          }
          CourseRatingWidget.showThanksForFeedbackDialog(context);
          // Reloads the orders data after submitting the rating
          context
              .read<MyOrdersBloc>()
              .add(const MyOrdersDataEvent(isFirstTime: true));
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
                borderRadius: BorderRadius.circular(AppDimensions.mediumXL),
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
                        // Title of the rating section
                        ProfileKeys.experienceSoFar.stringToString
                            .titleBold(
                                color: AppColors.black,
                                size: AppDimensions.large.sp,
                                align: TextAlign.center)
                            .symmetricPadding(
                                horizontal: AppDimensions.mediumXL.w),
                        AppDimensions.small.verticalSpace,
                        // Subtitle or description
                        ProfileKeys.loveToKnow.stringToString.titleRegular(
                            color: AppColors.grey9098A3,
                            size: AppDimensions.medium.sp),
                        AppDimensions.medium.verticalSpace,
                        // Rating bar for user to provide rating
                        SizedBox(
                          width: double.infinity,
                          child: RatingBarWidget(
                            rating: state is CourseRatingsUpdatedState
                                ? state.ratings
                                : 0.0,
                            onChanged: (val) {
                              rating = val;
                              // Updates the rating in the bloc
                              context.read<CourseRatingsBloc>().add(
                                  RatingsUpdateEvent(
                                      ratings: rating,
                                      feedback: feedbackController.text));
                            },
                          ),
                        ),
                        AppDimensions.large.verticalSpace,
                        // Feedback text field
                        Container(
                          height: 20 * 8,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.black.withOpacity(0.1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(6.w)),
                          // Limits the number of lines to 5
                          child: TextField(
                            onChanged: (text) {
                              // Updates the feedback in the bloc
                              context.read<CourseRatingsBloc>().add(
                                  RatingsUpdateEvent(
                                      ratings: rating, feedback: text));
                              feedbackController.text = text;
                            },
                            style: TextStyle(
                                fontSize: AppDimensions.medium.sp,
                                color: AppColors.countryCodeColor),
                            maxLines: 5,
                            controller: feedbackController,
                            inputFormatters: [
                              // Restricts the number of lines to 5
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
                        // Submit button for feedback
                        ButtonWidget(
                          title: ProfileKeys.send.stringToString,
                          isValid: (state is CourseRatingsUpdatedState &&
                              state.feedback.isNotEmpty),
                          onPressed: () {
                            // Triggers the submission of the rating
                            context.read<CourseRatingsBloc>().add(
                                RatingsSubmitEvent(
                                    ratings: rating,
                                    feedback: feedbackController.text));
                          },
                        ),
                        AppDimensions.large.verticalSpace
                      ],
                    ).paddingAll(padding: AppDimensions.mediumXL),
                  ),
                ),
                // Loading animation during state update
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
