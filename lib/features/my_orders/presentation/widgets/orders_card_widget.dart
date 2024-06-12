import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/my_orders/presentation/blocs/course_rating_bloc/course_ratings_bloc.dart';
import 'package:xplor/features/my_orders/presentation/blocs/my_orders_bloc/my_orders_bloc.dart';
import 'package:xplor/features/my_orders/presentation/widgets/course_rating_widget.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/padding.dart';
import 'package:xplor/utils/extensions/space.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/outlined_button.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../../utils/widgets/primary_button.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../domain/entities/my_orders_entity.dart';
import '../blocs/my_orders_bloc/my_orders_event.dart';

class OrdersCardWidget extends StatefulWidget {
  const OrdersCardWidget({
    super.key,
    required this.myOrdersEntity,
    this.isCompleted = false,
    required this.progress,
  });

  final MyOrdersEntity myOrdersEntity;
  final bool isCompleted;
  final double progress;

  @override
  State<OrdersCardWidget> createState() => _OrdersCardWidgetState();
}

class _OrdersCardWidgetState extends State<OrdersCardWidget> {
  @override
  Widget build(BuildContext context) {
    double progressValue = widget.progress;
    bool isDisable = widget.myOrdersEntity.rating!.rating!.isNotEmpty &&
        widget.myOrdersEntity.rating!.review!.isNotEmpty;
    return GestureDetector(
        onTap: () {
          if (widget.myOrdersEntity.fulfillment!.media!.isNotEmpty) {
            sl<SharedPreferencesHelper>()
                .setBoolean(PrefConstKeys.isStartUrlMyCourse, true);
            Navigator.pushNamed(context, Routes.startCoursePage,
                arguments: widget.myOrdersEntity.fulfillment!.media?[0].url);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.medium),
            boxShadow: const [
              BoxShadow(
                color: AppColors.searchShadowColor, // Shadow color
                offset: Offset(0, 1), // Offset
                blurRadius: 1, // Blur radius
              ),
            ],
          ),
          child: Card(
            elevation: 0,
            surfaceTintColor: AppColors.white,
            color: AppColors.white,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5.77.sp),
                          child: CachedNetworkImage(
                              height: 55.sp,
                              width: 55.sp,
                              imageUrl: widget.myOrdersEntity.itemDetails!
                                      .descriptor!.images!.isNotEmpty
                                  ? widget.myOrdersEntity.itemDetails!
                                      .descriptor!.images!.first
                                  : "",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                    child: LoadingAnimation(),
                                  ),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                    height: 55.sp,
                                    width: 55.sp,
                                    fit: BoxFit.fill,
                                    Assets.images.productThumnail,
                                  ))),
                      AppDimensions.smallXL.hSpace(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.myOrdersEntity.itemDetails!.descriptor!.name!
                                .titleBold(
                              size: AppDimensions.medium.sp,
                              overflow: TextOverflow.ellipsis,
                              maxLine: 2,
                            ),
                            AppDimensions.small.vSpace(),
                            /* if (widget.myOrdersEntity.internalItemId!.descriptor
                                    .shortDesc !=
                                "")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.images.personIcon,
                                      ),
                                      5.hSpace(),
                                      widget.myOrdersEntity.internalItemId!
                                          .descriptor.shortDesc
                                          .titleRegular(
                                        size: AppDimensions.smallXL.sp,
                                        color: AppColors.grey64697a,
                                      ),
                                    ],
                                  ),
                                  AppDimensions.extraLarge.hSpace(),
                                  */ /*  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.images.lessons,
                                        width: 9.5,
                                        height: 11,
                                      ),
                                      5.hSpace(),
                                      widget.myOrdersEntity.lessons!.titleBold(
                                        size: AppDimensions.smallXL.sp,
                                        color: AppColors.grey64697a,
                                      ),
                                    ],
                                  ),*/ /*
                                ],
                              ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                  AppDimensions.smallXL.vSpace(),
                  // if (widget.myOrdersEntity.domain != null &&
                  //     widget.myOrdersEntity.domain ==
                  //         OrderTypeKeys.BELEM_COURSE_DOMAIN)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProfileKeys.courseProgress.stringToString
                          .titleBold(size: 12.sp),
                      "${(progressValue * 100).toStringAsFixed(0)}% ${ProfileKeys.completed.stringToString}"
                          .titleSemiBold(
                              size: 10.sp, color: AppColors.grey64697a),
                    ],
                  ),
                  // if (widget.myOrdersEntity.domain != null &&
                  //     widget.myOrdersEntity.domain ==
                  //         OrderTypeKeys.BELEM_COURSE_DOMAIN)
                  AppDimensions.small.vSpace(),
                  // if (widget.myOrdersEntity.domain != null &&
                  //     widget.myOrdersEntity.domain ==
                  //         OrderTypeKeys.BELEM_COURSE_DOMAIN)
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progressValue,
                            backgroundColor: AppColors.checkBoxDisableColor,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor),
                            minHeight: 7.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.isCompleted) AppDimensions.medium.vSpace(),
                  if (widget.isCompleted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: PrimaryButton(
                            onTap: () {
                              if (!isDisable) {
                                context.read<CourseRatingsBloc>().orderId =
                                    widget.myOrdersEntity.id ?? '';
                                CourseRatingWidget.showRatingsBottomSheet(
                                    context);
                              }
                            },
                            disabled: isDisable,
                            title: ProfileKeys.rateAndReview.stringToString,
                          ),
                        ),
                        AppDimensions.smallXL.hSpace(),
                        Expanded(
                          child: OutLinedButton(
                            onTap: () {
                              if (widget
                                  .myOrdersEntity.certificateUrl!.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  Routes.certificate,
                                  arguments:
                                      widget.myOrdersEntity.certificateUrl,
                                );
                              } else {
                                context.read<MyOrdersBloc>().add(
                                    MyOrdersStatusEvent(
                                        orderItem: widget.myOrdersEntity));
                              }
                            },
                            title: ProfileKeys.getCertificate.stringToString,
                          ),
                        ),
                      ],
                    ),
                ]).paddingAll(padding: AppDimensions.small),
          ),
        ));
  }
}
