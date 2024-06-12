import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/apply_course/presentation/blocs/apply_course_bloc.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_event.dart';
import 'package:xplor/gen/assets.gen.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/common_top_header.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';
import 'package:xplor/utils/widgets/custom_text_form_fields.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../widgets/tags_list_widget.dart';

class ShareDocumentScreen extends StatefulWidget {
  // final VoidCallback onConfirmPressed;
  // final DocumentVcData? documentVcData;
  // final List<DocumentVcData>? selectedDocs;

  const ShareDocumentScreen({super.key});

  @override
  State<ShareDocumentScreen> createState() => _ShareDocumentScreenState();
}

class _ShareDocumentScreenState extends State<ShareDocumentScreen> {
  TextEditingController controller = TextEditingController();

  String remarksValue = '';
  TextEditingController validatorController = TextEditingController();
  int customDays = 0;
  DateTime? _selectedDate;
  bool customDaysSelected = false;

  @override
  void initState() {
    validatorController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SharedDocVcBloc, SharedDocVcState>(listener: (context, state) {
      if (state is ShareDocumentsUpdatedState && state.shareState == ShareState.success) {
        if (context.read<WalletVcBloc>().flowType == FlowType.course) {
          AppUtils.copyToClipboard(context, sl<SharedPreferencesHelper>().getString(PrefConstKeys.sharedId));
          context.read<ApplyCourseBloc>().add(const DocumentLinkCopiedEvent());

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (context.read<WalletVcBloc>().flowType == FlowType.document) {
          Navigator.pop(context);
          Navigator.pop(context);
          AppUtils.shareFile('');
        }

        context.read<WalletVcBloc>().add(const WalletDocumentsUnselectedEvent());
        context.read<SharedDocVcBloc>().add(const SharedDocVcInitialEvent());
      } else if (state is ShareDocumentsUpdatedState && state.shareState == ShareState.failure) {}
    }, child: BlocBuilder<SharedDocVcBloc, SharedDocVcState>(builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: state is ShareDocumentsUpdatedState
            ? AppBackgroundDecoration(
                child: Column(children: [
                  CommonTopHeader(
                    title: WalletKeys.shareDocument.stringToString,
                    onBackButtonPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                      child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: AppColors.white,
                            surfaceTintColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            child: SizedBox(
                              height: 58.w,
                              child: Row(
                                children: [
                                  state.documentVcData != null
                                      ? SvgPicture.asset(
                                          AppUtils.loadThumbnailBasedOnMimeTime(state.documentVcData?.fileType),
                                          height: 29.w,
                                          width: 24.w,
                                        )
                                      : state.selectedDocs!.length > 1
                                          ? SvgPicture.asset(
                                              AppUtils.loadThumbnailBasedOnMimeTime(null),
                                              height: 29.w,
                                              width: 24.w,
                                            )
                                          : SvgPicture.asset(
                                              AppUtils.loadThumbnailBasedOnMimeTime(state.selectedDocs![0].fileType),
                                              height: 29.w,
                                              width: 24.w,
                                            ),
                                  AppDimensions.medium.horizontalSpace,
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      state.documentVcData != null
                                          ? Expanded(
                                              child:
                                                  state.documentVcData!.name.titleBoldWithDots(size: 14.sp, maxLine: 1),
                                            )
                                          : state.selectedDocs!.length > 1
                                              ? Expanded(
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child:
                                                        '${state.selectedDocs!.length} ${WalletKeys.files.stringToString}'
                                                            .titleBold(size: 14.sp),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: state.selectedDocs![0].name
                                                      .titleBoldWithDots(size: 14.sp, maxLine: 1),
                                                ),
                                      AppDimensions.extraExtraSmall.verticalSpace,
                                      state.documentVcData != null
                                          ? Expanded(
                                              child: TagListWidgets(
                                                tags: state.documentVcData!.tags,
                                              ),
                                            )
                                          : state.selectedDocs?.length == 1
                                              ? Expanded(
                                                  child: TagListWidgets(
                                                    tags: state.selectedDocs![0].tags,
                                                  ),
                                                )
                                              : Container(),
                                    ],
                                  )),
                                ],
                              ).symmetricPadding(vertical: AppDimensions.small.w, horizontal: AppDimensions.medium.w),
                            ),
                          ),
                          20.verticalSpace,
                          CustomTextFormField(
                            controller: controller,
                            label: WalletKeys.remarks.stringToString,
                            hintText: WalletKeys.enterSomeRemarks.stringToString,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                              LengthLimitingTextInputFormatter(50)
                            ],
                            onChanged: (data) {
                              remarksValue = data;
                              context
                                  .read<SharedDocVcBloc>()
                                  .add(ShareDocVcUpdatedEvent(validity: state.validity, remarks: data));
                            },
                            onFieldSubmitted: (data) {
                              remarksValue = data;
                              context
                                  .read<SharedDocVcBloc>()
                                  .add(ShareDocVcUpdatedEvent(validity: state.validity, remarks: data));
                            },
                          ),
                        ],
                      ).singleSidePadding(
                        left: AppDimensions.medium.w,
                        right: AppDimensions.medium.w,
                        top: AppDimensions.extraLarge.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WalletKeys.validity.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
                          AppDimensions.small.verticalSpace,
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Handle onTap action here
                                context
                                    .read<SharedDocVcBloc>()
                                    .add(ShareDocVcUpdatedEvent(validity: Validity.once, remarks: remarksValue));
                              },
                              child: Card(
                                margin: EdgeInsets.only(bottom: 10.w),
                                surfaceTintColor: Colors.white.withOpacity(0.62),
                                color: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.w),
                                  side: BorderSide(
                                      color: state.validity == Validity.once
                                          ? AppColors.primaryColor.withOpacity(0.26)
                                          : AppColors.white,
                                      width: state.validity == Validity.once ? 2 : 1), // Border color and width
                                ),
                                child: Row(
                                  children: [
                                    state.validity == Validity.once
                                        ? SvgPicture.asset(
                                            Assets.images.icRadioSelected,
                                            height: 20.w,
                                            width: 20.w,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            size: AppDimensions.mediumXL.w,
                                            color: AppColors.greyBorderC1,
                                          ),
                                    SizedBox(width: 20.w),
                                    // Add spacing between leading and title
                                    Expanded(
                                        child: WalletKeys.onceOnly.stringToString
                                            .titleRegular(size: 14.sp, color: AppColors.grey64697a)),
                                  ],
                                ).paddingAll(padding: AppDimensions.medium.w),
                              )),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Handle onTap action here
                                context
                                    .read<SharedDocVcBloc>()
                                    .add(ShareDocVcUpdatedEvent(validity: Validity.oneDay, remarks: remarksValue));
                              },
                              child: Card(
                                color: AppColors.white,
                                margin: EdgeInsets.only(bottom: 10.w),
                                surfaceTintColor: Colors.white.withOpacity(0.62),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.w),
                                  side: BorderSide(
                                      color: state.validity == Validity.oneDay
                                          ? AppColors.primaryColor.withOpacity(0.26)
                                          : AppColors.white,
                                      width: state.validity == Validity.oneDay ? 2 : 1), // Border color and width
                                ),
                                child: Row(
                                  children: [
                                    state.validity == Validity.oneDay
                                        ? SvgPicture.asset(
                                            Assets.images.icRadioSelected,
                                            height: 20.w,
                                            width: 20.w,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            size: AppDimensions.mediumXL.w,
                                            color: AppColors.greyBorderC1,
                                          ),
                                    SizedBox(width: 20.w),
                                    // Add spacing between leading and title
                                    Expanded(
                                        child: WalletKeys.oneDay.stringToString
                                            .titleRegular(size: 14.sp, color: AppColors.grey64697a)),
                                  ],
                                ).paddingAll(padding: AppDimensions.medium.w),
                              )),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Handle onTap action here
                                context
                                    .read<SharedDocVcBloc>()
                                    .add(ShareDocVcUpdatedEvent(validity: Validity.threeDays, remarks: remarksValue));
                              },
                              child: Card(
                                color: AppColors.white,
                                margin: EdgeInsets.only(bottom: 10.w),
                                surfaceTintColor: Colors.white.withOpacity(0.62),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.w),
                                  side: BorderSide(
                                      color: state.validity == Validity.threeDays
                                          ? AppColors.primaryColor.withOpacity(0.26)
                                          : AppColors.white,
                                      width: state.validity == Validity.threeDays ? 2 : 1), // Border color and width
                                ),
                                child: Row(
                                  children: [
                                    state.validity == Validity.threeDays
                                        ? SvgPicture.asset(
                                            Assets.images.icRadioSelected,
                                            height: 20.w,
                                            width: 20.w,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            size: AppDimensions.mediumXL.w,
                                            color: AppColors.greyBorderC1,
                                          ),
                                    SizedBox(width: 20.w),
                                    // Add spacing between leading and title
                                    Expanded(
                                        child: WalletKeys.threeDays.stringToString
                                            .titleRegular(size: 14.sp, color: AppColors.grey64697a)),
                                  ],
                                ).paddingAll(padding: AppDimensions.medium.w),
                              )),
                          AppDimensions.extraExtraSmall.horizontalSpace,
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                // Handle onTap action here
                                customDaysSelected = true;
                                _showDatePicker(4);
                              },
                              child: Card(
                                color: AppColors.white,
                                margin: EdgeInsets.only(bottom: 10.w),
                                surfaceTintColor: Colors.white.withOpacity(0.62),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.w),
                                  side: BorderSide(
                                      color: state.validity == Validity.customDays
                                          ? AppColors.primaryColor.withOpacity(0.26)
                                          : AppColors.white,
                                      width: state.validity == Validity.customDays ? 2 : 1), // Border color and width
                                ),
                                child: Row(
                                  children: [
                                    state.validity == Validity.customDays
                                        ? SvgPicture.asset(
                                            Assets.images.icRadioSelected,
                                            height: 20.w,
                                            width: 20.w,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            size: AppDimensions.mediumXL.w,
                                            color: AppColors.greyBorderC1,
                                          ),
                                    SizedBox(width: AppDimensions.medium.w),
                                    // Add spacing between leading and title
                                    Expanded(
                                        child: state.validity == Validity.customDays
                                            ? '$customDays ${WalletKeys.days.stringToString}'
                                                .titleRegular(size: 14.sp, color: AppColors.grey64697a)
                                            : WalletKeys.customDaysString.stringToString
                                                .titleRegular(size: 14.sp, color: AppColors.grey64697a)),
                                  ],
                                ).paddingAll(padding: AppDimensions.medium.w),
                              ))
                        ],
                      ).symmetricPadding(horizontal: AppDimensions.medium.w, vertical: AppDimensions.extraSmall.w),
                    ],
                  )),
                  AppDimensions.extraSmall.vSpace(),
                  ButtonWidget(
                      isValid: state.inputText.isNotEmpty,
                      customText: Row(
                        children: [
                          const Spacer(),
                          state.shareState == ShareState.loading
                              ? WalletKeys.pleaseWait.stringToString.titleBold(color: AppColors.white, size: 14.sp)
                              : WalletKeys.shareDocument.stringToString.titleBold(color: AppColors.white, size: 14.sp),
                          AppDimensions.small.hSpace(),
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.white,
                            size: AppDimensions.medium,
                          ),
                          const Spacer()
                        ],
                      ),
                      /* buttonBackgroundColor: remarksValue.isNotEmpty
                          ? AppColors.blue1E88E5
                          : AppColors.cancelButtonBgColor,*/
                      onPressed: () {
                        if (state.shareState == ShareState.loading) {
                          return;
                        }
                        var isMpinGenerated = sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.isMpinCreated);
                        isMpinGenerated
                            ? AppUtilsDialogMixin.askForMPINDialog(context)
                            : Navigator.pushNamed(
                                context,
                                Routes.mpin,
                              );
                      }).symmetricPadding(horizontal: AppDimensions.medium, vertical: AppDimensions.large.w),
                ]).symmetricPadding(),
              )
            : Container(),
      );
    }));
  }

  void _showDatePicker(int? value) async {
    _selectedDate = DateTime.now().add(const Duration(days: 5));
    // Show the CupertinoDatePicker at the bottom of the screen
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppDimensions.mediumXL.vSpace(),
            WalletKeys.selectDate.stringToString.titleBold(size: 18.sp),
            AppDimensions.smallXL.vSpace(),
            // CupertinoDatePicker
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate ?? DateTime.now().add(const Duration(days: 5)),
                minimumDate: DateTime.now().add(const Duration(days: 4)),
                maximumDate: DateTime.now().add(const Duration(days: 365)),
                // Limit to one year from today
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  // Store the selected date
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            ),
            // OK and Cancel buttons
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    isFilled: false,
                    radius: AppDimensions.small,
                    buttonBackgroundColor: AppColors.white,
                    buttonForegroundColor: AppColors.white,
                    customText: WalletKeys.cancel.stringToString.titleBold(size: 14, color: AppColors.primaryColor),
                    isValid: true,
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet without selecting a date
                    },
                  ).symmetricPadding(horizontal: 10),
                ),
                Expanded(
                  child: ButtonWidget(
                    title: WalletKeys.ok.stringToString,
                    radius: AppDimensions.small,
                    isValid: true,
                    onPressed: () {
                      // Handle OK button press

                      // Calculate the difference in days between today and the selected date
                      customDays = _selectedDate!.difference(DateTime.now()).inDays + 1;
                      setState(() {});

                      // Assign the difference to validatorController.text
                      validatorController.text = value.toString();
                      // Dispatch event to the bloc

                      context.read<SharedDocVcBloc>().validity = validatorController.text;
                      context.read<SharedDocVcBloc>().customDays = customDays;
                      context
                          .read<SharedDocVcBloc>()
                          .add(ShareDocVcUpdatedEvent(validity: Validity.customDays, remarks: remarksValue));

                      Navigator.pop(context); // Close the bottom sheet after selecting date
                    },
                  ).symmetricPadding(horizontal: 10),
                ),
              ],
            ),
            AppDimensions.smallXL.vSpace(),
          ],
        );
      },
    );
  }
}
