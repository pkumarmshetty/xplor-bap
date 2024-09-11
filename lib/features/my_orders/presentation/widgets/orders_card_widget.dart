import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../domain/entities/certificate_view_arguments.dart';
import '../blocs/course_rating_bloc/course_ratings_bloc.dart';
import '../blocs/my_orders_bloc/my_orders_bloc.dart';
import 'course_rating_widget.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/widgets/outlined_button.dart';
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

/// Widget to display an individual order card.
class OrdersCardWidget extends StatefulWidget {
  const OrdersCardWidget({
    super.key,
    required this.myOrdersEntity,
    this.isCompleted = false,
    required this.progress,
    required this.position,
  });

  final MyOrdersEntity myOrdersEntity;
  final bool isCompleted;
  final double? progress;
  final int position;

  @override
  State<OrdersCardWidget> createState() => _OrdersCardWidgetState();
}

class _OrdersCardWidgetState extends State<OrdersCardWidget> {
  @override
  Widget build(BuildContext context) {
    double progressValue = widget.progress ?? 0.0;
    bool isDisable =
        widget.myOrdersEntity.rating!.rating!.isNotEmpty && widget.myOrdersEntity.rating!.review!.isNotEmpty;
    return GestureDetector(
        onTap: () {
          if (widget.myOrdersEntity.fulfillment!.media!.isNotEmpty) {
            sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isStartUrlMyCourse, true);
            Navigator.pushNamed(context, Routes.startCoursePage,
                arguments: widget.myOrdersEntity.fulfillment!.media?[0].url);
          }
        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: (widget.myOrdersEntity.courseProgress == null && !widget.isCompleted)
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(AppDimensions.medium),
                        topRight: Radius.circular(AppDimensions.medium),
                        bottomLeft: Radius.circular(AppDimensions.medium))
                    : BorderRadius.circular(AppDimensions.medium),
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
                                  imageUrl: widget.myOrdersEntity.itemDetails!.descriptor!.images!.isNotEmpty
                                      ? widget.myOrdersEntity.itemDetails!.descriptor!.images!.first
                                      : "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                        child: LoadingAnimation(),
                                      ),
                                  errorWidget: (context, url, error) => SvgPicture.asset(
                                        height: 55.sp,
                                        width: 55.sp,
                                        fit: BoxFit.fill,
                                        Assets.images.productThumnail,
                                      ))),
                          AppDimensions.smallXL.w.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                widget.myOrdersEntity.itemDetails!.descriptor!.name!.titleBold(
                                  size: AppDimensions.medium.sp,
                                  overflow: TextOverflow.ellipsis,
                                  maxLine: 2,
                                ),
                                AppDimensions.small.verticalSpace,
                              ],
                            ),
                          )
                        ],
                      ),
                      (widget.myOrdersEntity.courseProgress == null && !widget.isCompleted)
                          ? Container()
                          : Column(
                              children: [
                                AppDimensions.smallXL.verticalSpace,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileKeys.courseProgress.stringToString.titleBold(size: 12.sp),
                                    "${(progressValue * 100).toStringAsFixed(0)}% ${ProfileKeys.completed.stringToString}"
                                        .titleSemiBold(size: 10.sp, color: AppColors.grey64697a),
                                  ],
                                ),
                                AppDimensions.small.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: progressValue,
                                          backgroundColor: AppColors.checkBoxDisableColor,
                                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                          minHeight: 7.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                      // if (widget.myOrdersEntity.domain != null &&
                      //     widget.myOrdersEntity.domain ==
                      //         OrderTypeKeys.BELEM_COURSE_DOMAIN)

                      // if (widget.myOrdersEntity.domain != null &&
                      //     widget.myOrdersEntity.domain ==
                      //         OrderTypeKeys.BELEM_COURSE_DOMAIN)
                      if (widget.isCompleted) AppDimensions.medium.verticalSpace,
                      if (widget.isCompleted)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                onTap: () {
                                  if (!isDisable) {
                                    context.read<CourseRatingsBloc>().orderId = widget.myOrdersEntity.id ?? '';
                                    CourseRatingWidget.showRatingsBottomSheet(context);
                                  }
                                },
                                disabled: isDisable,
                                title: ProfileKeys.rateAndReview.stringToString,
                              ),
                            ),
                            AppDimensions.smallXL.w.horizontalSpace,
                            Expanded(
                              child: OutLinedButton(
                                onTap: () {
                                  if (widget.myOrdersEntity.certificateUrl!.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.certificate,
                                      arguments: CertificateViewArguments(
                                          certificateUrl: widget.myOrdersEntity.certificateUrl!,
                                          ordersEntity: widget.myOrdersEntity),
                                    );
                                  } else {
                                    context.read<MyOrdersBloc>().add(MyOrdersStatusEvent(
                                        orderItem: widget.myOrdersEntity, position: widget.position));
                                  }
                                },
                                title: ProfileKeys.getCertificate.stringToString,
                              ),
                            ),
                          ],
                        ),
                    ]).paddingAll(padding: AppDimensions.small),
              ),
            ),
            if (widget.myOrdersEntity.courseProgress == null && !widget.isCompleted)
              Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: PrimaryButton(
                    onTap: () {
                      context.read<MyOrdersBloc>().add(MyOrdersStatusEvent(
                          orderItem: widget.myOrdersEntity, isFromOngoing: true, position: widget.position));
                    },
                    disabled: false,
                    title: ProfileKeys.checkProgress.stringToString,
                  ),
                ),
              )
          ],
        ));
  }
}
