import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xplor/features/wallet/presentation/widgets/tags_list_widget.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/padding.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/custom_text_form_fields.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../domain/entities/shared_data_entity.dart';

/// A widget to display and update the consent header information.
///
/// The `UpdateConsentHeaderWidget` class is a stateful widget that allows users to view and update consent details.
class UpdateConsentHeaderWidget extends StatefulWidget {
  /// The shared data entity containing consent details.
  final SharedVcDataEntity? entity;

  /// A controller for the remarks text field.
  final TextEditingController remarksController;

  /// A callback function to handle changes in the remarks text field.
  final Function(String)? onChanged;

  const UpdateConsentHeaderWidget({
    super.key,
    this.entity,
    required this.remarksController,
    this.onChanged,
  });

  @override
  State<UpdateConsentHeaderWidget> createState() =>
      _UpdateConsentHeaderWidgetState();
}

class _UpdateConsentHeaderWidgetState extends State<UpdateConsentHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
      children: [
        // Display the "Shared To" label
        WalletKeys.sharedTo.stringToString
            .titleBold(size: 14.sp, color: AppColors.countryCodeColor),
        AppDimensions.extraSmall.verticalSpace, // Add vertical space
        Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
          // Set vertical margin
          decoration: BoxDecoration(
            color: Colors.white, // Background color for the container
            border: Border.all(
              color: AppColors.greyBorderC1, // Border color
              width: 1.w, // Border width
            ),
            borderRadius:
                BorderRadius.circular(AppDimensions.small), // Rounded corners
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // Align items to the start
            children: [
              AppDimensions.smallXL.w.horizontalSpace,
              // Add horizontal space
              Image.asset(
                Assets.images.consent.path, // Load consent image
                height: 44.w, // Set image height
                width: 44.w, // Set image width
              ),
              AppDimensions.smallXL.w.horizontalSpace,
              // Add horizontal space
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align items to the start
                children: [
                  // Display the entity's shared with title
                  widget.entity!.sharedWithEntity.titleBold(
                    size: 14.sp,
                    color: AppColors.countryCodeColor,
                  ),
                  Row(
                    children: [
                      AppDimensions
                          .extraSmall.verticalSpace, // Add vertical space
                      // Display the creation date of the consent
                      AppUtils.convertDateFormat(
                              widget.entity!.vcDetails.createdAt)
                          .titleSemiBold(
                              size: 10.sp, color: AppColors.hintColor),
                      AppDimensions
                          .extraSmall.w.horizontalSpace, // Add horizontal space
                      // Display a dot separator
                      '•'.titleSemiBold(
                          size: 20.sp, color: AppColors.hintColor),
                      AppDimensions
                          .extraSmall.w.horizontalSpace, // Add horizontal space
                      // Display the status of the consent
                      widget.entity!.status.titleSemiBold(
                          size: 12.sp, color: AppColors.activeGreen),
                    ],
                  )
                ],
              ).paddingAll(padding: AppDimensions.small),
              // Add padding around the column
            ],
          ),
        ),
        AppDimensions.smallXL.verticalSpace, // Add vertical space
        // Display the "Shared File" label
        WalletKeys.sharedFile.stringToString
            .titleBold(size: 14.sp, color: AppColors.countryCodeColor),
        AppDimensions.small.verticalSpace, // Add vertical space
        Container(
          height: 60.w,
          // Set the container height
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // Rounded corners
              border: Border.all(color: AppColors.greyBorderC1, width: 1)),
          // Border styling
          child: Padding(
            padding: const EdgeInsets.only(
                left: AppDimensions.smallXL, right: 10, top: 10),
            // Padding inside the container
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  // Add padding to the bottom
                  child: widget.entity?.fileDetails.fileType == "text/html"
                      ? AppUtils.loadText(widget.entity!.vcDetails.tags,
                          fontSize: AppDimensions.extraLarge.sp)
                      : SvgPicture.asset(
                          AppUtils.loadThumbnailBasedOnMimeTime(
                              widget.entity?.fileDetails.fileType),
                          // Load the appropriate thumbnail based on file type
                          height:
                              AppDimensions.xxl.w, // Set the thumbnail height
                          width:
                              AppDimensions.large.w, // Set the thumbnail width
                        ),
                ),
                15.w.horizontalSpace, // Add horizontal space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align items to the start
                    children: [
                      // Display the name of the file
                      widget.entity!.vcDetails.name.titleBold(
                          size: 16.sp,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis),
                      TagListWidgets(tags: widget.entity!.vcDetails.tags)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppDimensions.mediumXL.verticalSpace, // Add vertical space
        // Display the remarks input field
        CustomTextFormField(
          controller: widget.remarksController,
          // Set the controller for the text field
          label: WalletKeys.remarks.stringToString,
          // Set the label for the text field
          hintText: WalletKeys.enterSomeRemarks.stringToString,
          // Set the hint text
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
            // Allow only alphanumeric characters and spaces
            LengthLimitingTextInputFormatter(50),
            // Limit the text length to 50 characters
          ],
          onChanged:
              widget.onChanged, // Call the onChanged callback when text changes
        ),
        /*
        Uncomment and use this section to display suggested tags
        10verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align items to the center
          children: [
            suggestedTags.stringToString.titleRegular(
                color: AppColors.greyBorderC1, size: 14.sp), // Display suggested tags text
            5.w.horizontalSpace, // Add horizontal space
            Expanded(
              child: SizedBox(
                height: 20, // Set the height for the suggested tags
                child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Set horizontal scroll direction
                    itemCount: 3, // Number of suggested tags
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: AppDimensions.extraSmall), // Add right padding
                        child: AspectRatio(
                          aspectRatio: 1.7 / 0.5, // Set aspect ratio for suggested tags
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                              color: AppColors.lightBlue6f0fa, // Background color
                            ),
                            child: Center(
                              child: scholarship.stringToString
                                  .titleSemiBold(size: 8.sp), // Display the tag text
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
        */
        AppDimensions.mediumXL.verticalSpace, // Add vertical space
        // Display the "Validity" label
        WalletKeys.validity.stringToString.titleBold(size: 14.sp),
        5.verticalSpace, // Add vertical space
      ],
    ).symmetricPadding(
        horizontal:
            AppDimensions.mediumXL); // Add horizontal padding around the column
  }
}
