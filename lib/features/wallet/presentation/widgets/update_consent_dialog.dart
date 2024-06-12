import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/domain/mappers/wallet/wallet_keys.dart';
import 'package:xplor/features/wallet/domain/entities/shared_data_entity.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_bloc.dart';
import 'package:xplor/features/wallet/presentation/blocs/update_consent_dialog_bloc/update_consent_dialog_state.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/custom_text_form_fields.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/top_header_for_dialogs.dart';
import '../../domain/entities/update_consent_entity.dart';
import '../blocs/my_consent_bloc/my_consent_bloc.dart';
import '../blocs/my_consent_bloc/my_consent_event.dart';
import '../blocs/update_consent_dialog_bloc/update_consent_dialog_event.dart';

class UpdateConsentDialogWidget extends StatefulWidget {
  final VoidCallback onConfirmPressed;
  final SharedVcDataEntity? entity;

  const UpdateConsentDialogWidget({
    super.key,
    required this.onConfirmPressed,
    this.entity,
  });

  @override
  State<UpdateConsentDialogWidget> createState() => _UpdateConsentDialogWidgetState();
}

class _UpdateConsentDialogWidgetState extends State<UpdateConsentDialogWidget> {
  final TextEditingController remarksController = TextEditingController();

  String remarksValue = '';
  DateTime? _selectedDate;
  bool customDaysSelected = false;

  TextEditingController validatorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var restrictions = widget.entity?.vcShareDetails.restrictions;
    customDays = restrictions?.expiresIn ?? 0;
    customDays = (customDays / 24).round();

    if (restrictions?.viewOnce == true) {
      validatorController.text = "1";
    } else {
      switch (restrictions?.expiresIn) {
        case 24:
          {
            validatorController.text = "2";
          }
        case 72:
          {
            validatorController.text = "3";
          }
        default:
          {
            validatorController.text = "4";
            customDaysSelected = true;
            _selectedDate = DateTime.now().add(Duration(days: customDays));
          }
      }
    }
    context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(
        selectedItem: int.parse(validatorController.text), remarks: widget.entity?.remarks ?? ''));
    remarksController.text = widget.entity?.remarks ?? '';
    remarksValue = widget.entity?.remarks ?? '';
  }

  var customDays = 0;

  @override
  Widget build(BuildContext context) {
    /* if (remarksController.text.isEmpty) {
      remarksController.text = widget.entity?.remarks ?? '';
      remarksValue = widget.entity?.remarks ?? '';
    }*/
    return BlocListener<UpdateConsentDialogBloc, UpdateConsentDialogState>(listener: (context, state) {
      if (state is MyConsentUpdateSuccessState) {
        context.read<MyConsentBloc>().add(const GetUserConsentEvent());
        Navigator.pop(context);
      }
    }, child: BlocBuilder<UpdateConsentDialogBloc, UpdateConsentDialogState>(builder: (context, state) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.medium),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
        child: SingleChildScrollView(
          child: Column(children: [
            TopHeaderForDialogs(title: WalletKeys.update.stringToString, isCrossIconVisible: true),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletKeys.sharedTo.stringToString.titleBold(size: 14.sp, color: AppColors.countryCodeColor),
                AppDimensions.extraSmall.vSpace(),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: AppDimensions.small),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.greyBorderC1,
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.small),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppDimensions.smallXL.hSpace(),
                        Image.asset(
                          Assets.images.consent.path,
                          height: 44.w,
                          width: 44.w,
                        ),
                        AppDimensions.smallXL.hSpace(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.entity!.sharedWithEntity.titleBold(
                              size: 14.sp,
                              color: AppColors.countryCodeColor,
                            ),
                            Row(
                              children: [
                                AppDimensions.extraSmall.vSpace(),
                                AppUtils.convertDateFormat(widget.entity!.vcDetails.createdAt)
                                    .titleSemiBold(size: 10.sp, color: AppColors.hintColor),
                                AppDimensions.extraSmall.hSpace(),
                                // Add space between the date/time and dot
                                '•'.titleSemiBold(size: 20.sp, color: AppColors.hintColor),
                                AppDimensions.extraSmall.hSpace(),
                                // Add space between the dot and the word "active"
                                widget.entity!.status.titleSemiBold(size: 12.sp, color: AppColors.activeGreen),
                              ],
                            )
                          ],
                        ).paddingAll(padding: AppDimensions.small),
                      ],
                    )),
                AppDimensions.smallXL.vSpace(),
                WalletKeys.sharedFile.stringToString.titleBold(size: 14.sp, color: AppColors.countryCodeColor),
                AppDimensions.small.vSpace(),
                Container(
                  height: 60.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.greyBorderC1, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 10, top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: SvgPicture.asset(
                            AppUtils.loadThumbnailBasedOnMimeTime(widget.entity?.fileDetails.fileType),
                            height: 32.w,
                            width: 24.w,
                          ),
                        ),
                        15.horizontalSpace,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.entity!.vcDetails.name.titleBold(size: 16.sp),
                            SizedBox(
                                height: 20,
                                // Adjust the height as needed
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.entity?.vcDetails.tags.length,
                                    // Adjust the number of items as needed
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 4.0),
                                        child: AspectRatio(
                                          aspectRatio: 1.7 / 0.5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10.0),
                                              // Set the border radius
                                              color: AppColors.lightBlue6f0fa, // Set the background color
                                            ),
                                            child: Center(
                                              child: (widget.entity?.vcDetails.tags[index] ?? '')
                                                  .titleSemiBold(size: 8.sp),
                                            ),
                                          ),
                                        ),
                                      );
                                    }))
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                20.verticalSpace,
                CustomTextFormField(
                  controller: remarksController,
                  label: WalletKeys.remarks.stringToString,
                  hintText: WalletKeys.enterSomeRemarks.stringToString,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                    LengthLimitingTextInputFormatter(50)
                    // Adjust as needed
                  ],
                  onChanged: (data) {
                    remarksValue = data;
                    context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(
                        remarks: data, selectedItem: (state as ConsentUpdateDialogUpdatedState).selectedItem));
                  },
                ),
                /*10.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    suggestedTags.stringToString.titleRegular(
                        color: AppColors.greyBorderC1, size: 14.sp),
                    5.horizontalSpace,
                    Expanded(
                      child: SizedBox(
                        height: 20,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: AspectRatio(
                                  aspectRatio: 1.7 / 0.5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      // Set the border radius
                                      color: AppColors
                                          .lightBlue6f0fa, // Set the background color
                                    ),
                                    child: Center(
                                      child: scholarship.stringToString
                                          .titleSemiBold(size: 8.sp),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),*/
                20.verticalSpace,
                WalletKeys.validity.stringToString.titleBold(size: 14.sp),
                5.verticalSpace,
              ],
            ).symmetricPadding(horizontal: AppDimensions.mediumXL),
            RadioListTile<int>(
              contentPadding: EdgeInsets.zero,
              title: Text(WalletKeys.onceOnly.stringToString),
              visualDensity: VisualDensity.compact,
              dense: true,
              value: 1,
              groupValue: int.parse(validatorController.text),
              onChanged: (value) {
                validatorController.text = value.toString();
                customDaysSelected = false;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 1));
              },
              activeColor: AppColors.blue1E88E5,
            ).singleSidePadding(left: 10),
            RadioListTile<int>(
              contentPadding: EdgeInsets.zero,
              title: Text(WalletKeys.oneDay.stringToString),
              visualDensity: VisualDensity.compact,
              dense: true,
              activeColor: AppColors.blue1E88E5,
              value: 2,
              groupValue: int.parse(validatorController.text),
              onChanged: (value) {
                validatorController.text = value.toString();
                customDaysSelected = false;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 2));
              },
            ).singleSidePadding(left: 10),
            RadioListTile<int>(
              contentPadding: EdgeInsets.zero,
              title: Text(WalletKeys.threeDays.stringToString),
              value: 3,
              visualDensity: VisualDensity.compact,
              dense: true,
              activeColor: AppColors.blue1E88E5,
              groupValue: int.parse(validatorController.text),
              onChanged: (value) {
                validatorController.text = value.toString();
                customDaysSelected = false;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 3));
              },
            ).singleSidePadding(left: 10),
            GestureDetector(
              onTap: () {
                customDaysSelected = true;
                _showDatePicker(4);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !customDaysSelected
                        ? const Icon(
                            Icons.radio_button_unchecked,
                            color: AppColors.black,
                            size: 22,
                          )
                        : const Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primaryColor,
                            size: 22,
                          ),
                    19.hSpace(),
                    Expanded(
                        child: Wrap(
                      children: [
                        Text(
                          _selectedDate == null
                              ? WalletKeys.customDaysString.stringToString
                              : '${customDays.toString()} ${WalletKeys.days.stringToString}',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ).singleSidePadding(left: 10),
            10.verticalSpace,
            ButtonWidget(
                isValid: remarksValue.isNotEmpty ? true : false,
                title: state is MyConsentLoaderState
                    ? WalletKeys.pleaseWait.stringToString
                    : remarksValue.isNotEmpty
                        ? WalletKeys.continueString.stringToString
                        : WalletKeys.shareDocument.stringToString,
                fontSize: 12.sp,
                onPressed: () {
                  if (state is MyConsentLoaderState) {
                    return;
                  }
                  bool viewOnce = int.parse(validatorController.text) == 1;

                  int getHoursAccordingToDaySelection(int expiresIn) {
                    if (expiresIn == 4) {
                      return customDays * 24;
                    } else {
                      return AppUtils.getHoursAccordingToDaySelection(int.parse(validatorController.text));
                    }
                  }

                  UpdateConsentEntity entity = UpdateConsentEntity(
                      remarks: remarksController.text,
                      sharedWithEntity: widget.entity!.sharedWithEntity,
                      restrictions: ConsentRestrictions(
                          expiresIn: getHoursAccordingToDaySelection(int.parse(validatorController.text)),
                          viewOnce: viewOnce));
                  context.read<UpdateConsentDialogBloc>().add(
                      ConsentUpdateDialogSubmittedEvent(requestId: widget.entity?.id ?? '', updateConsent: entity));
                }).symmetricPadding(horizontal: AppDimensions.medium),
            AppDimensions.medium.vSpace()
          ]),
        ),
      );
    }));
  }

  void _showDatePicker(int? value) async {
    _selectedDate ??= DateTime.now().add(const Duration(days: 5));
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
                      context
                          .read<UpdateConsentDialogBloc>()
                          .add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 4));

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
