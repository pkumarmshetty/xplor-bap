import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/custom_text_form_fields.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/top_header_for_dialogs.dart';
import '../../domain/entities/wallet_vc_list_entity.dart';
import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import 'enter_mpin_dialog.dart';
import 'tags_list_widget.dart';

class ShareDialogWidget extends StatefulWidget {
  final VoidCallback onConfirmPressed;
  final DocumentVcData? documentVcData;
  final List<DocumentVcData>? docsList;

  const ShareDialogWidget({super.key, required this.onConfirmPressed, required this.documentVcData, this.docsList});

  @override
  State<ShareDialogWidget> createState() => _ShareDialogWidgetState();
}

class _ShareDialogWidgetState extends State<ShareDialogWidget> {
  TextEditingController controller = TextEditingController();

  String remarksValue = '';

  TextEditingController validatorController = TextEditingController();
  int customDays = 0;

  @override
  void initState() {
    validatorController.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SharedDocVcBloc, SharedDocVcState>(listener: (context, state) {
      if (state is SharedSuccessState) {
        Navigator.pop(context);
        context.read<SharedDocVcBloc>().add(const SharedDocVcInitialEvent());

        var isMpinGenerated = sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.isMpinCreated);
        isMpinGenerated
            ? AppUtilsDialogMixin.askForMPINDialog(context)
            : Navigator.pushNamed(
                context,
                Routes.mpin,
              );
      } else if (state is SharedFailureState) {}
    }, child: BlocBuilder<SharedDocVcBloc, SharedDocVcState>(builder: (context, state) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.medium),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.medium),
        child: SingleChildScrollView(
          child: Column(children: [
            const TopHeaderForDialogs(title: 'Share Document', isCrossIconVisible: true),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.hintColor, width: 1.5)),
                    child: Row(
                      children: [
                        Align(
                            alignment: Alignment.center,
                            child: widget.documentVcData != null
                                ? SvgPicture.asset(
                                    AppUtils.loadThumbnailBasedOnMimeTime(widget.documentVcData?.fileType),
                                    height: 32.w,
                                    width: 24.w,
                                  )
                                : widget.docsList!.length > 1
                                    ? SvgPicture.asset(
                                        AppUtils.loadThumbnailBasedOnMimeTime(null),
                                        height: 32.w,
                                        width: 24.w,
                                      )
                                    : SvgPicture.asset(
                                        AppUtils.loadThumbnailBasedOnMimeTime(widget.docsList![0].fileType),
                                        height: 32.w,
                                        width: 24.w,
                                      )),
                        15.horizontalSpace,
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.documentVcData != null
                                ? Expanded(
                                    child: widget.documentVcData!.name.titleBoldWithDots(size: 14.sp, maxLine: 1),
                                  )
                                : widget.docsList!.length > 1
                                    ? Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: '${widget.docsList!.length} files'.titleBold(size: 14.sp),
                                        ),
                                      )
                                    : Expanded(
                                        child: widget.docsList![0].name.titleBoldWithDots(size: 14.sp, maxLine: 1),
                                      ),
                            2.verticalSpace,
                            widget.documentVcData != null
                                ? Expanded(
                                    child: TagListWidgets(
                                      tags: widget.documentVcData!.tags,
                                    ),
                                  )
                                : widget.docsList?.length == 1
                                    ? Expanded(
                                        child: TagListWidgets(
                                          tags: widget.docsList![0].tags,
                                        ),
                                      )
                                    : Container(),
                          ],
                        )),
                      ],
                    ).symmetricPadding(vertical: 5, horizontal: 12),
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    controller: controller,
                    label: 'Remarks',
                    hintText: 'Enter some remarks',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                      LengthLimitingTextInputFormatter(50)
                    ],
                    onChanged: (data) {
                      remarksValue = data;
                      context.read<SharedDocVcBloc>().add(ShareDocVcUpdatedEvent(remarks: data));
                    },
                    onFieldSubmitted: (data) {
                      remarksValue = data;
                      context.read<SharedDocVcBloc>().add(ShareDocVcUpdatedEvent(remarks: data));
                    },
                  ),
                  20.verticalSpace,
                  'Validity'.titleBold(size: 14.sp),
                  5.verticalSpace,
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Once only'),
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    value: 1,
                    groupValue: int.parse(validatorController.text),
                    onChanged: (value) {
                      validatorController.text = value.toString();

                      context.read<SharedDocVcBloc>().add(ShareDocVcUpdatedEvent(selectedItem: value ?? 1));
                    },
                    activeColor: AppColors.blue1E88E5,
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('1 Day'),
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    activeColor: AppColors.blue1E88E5,
                    value: 2,
                    groupValue: int.parse(validatorController.text),
                    onChanged: (value) {
                      validatorController.text = value.toString();

                      context.read<SharedDocVcBloc>().add(ShareDocVcUpdatedEvent(selectedItem: value ?? 2));
                    },
                  ),
                ),
              ],
            ).singleSidePadding(left: 10),
            2.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('3 Days'),
                    value: 3,
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    activeColor: AppColors.blue1E88E5,
                    groupValue: int.parse(validatorController.text),
                    onChanged: (value) {
                      validatorController.text = value.toString();

                      context.read<SharedDocVcBloc>().add(ShareDocVcUpdatedEvent(selectedItem: value ?? 3));
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(customDays == 0 ? 'Custom Days' : '${customDays.toString()} Days'),
                    value: 4,
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    activeColor: AppColors.blue1E88E5,
                    groupValue: int.parse(validatorController.text),
                    onChanged: (value) async {
                      // Define variables to store selected date
                      DateTime selectedDate = DateTime.now().add(const Duration(days: 5));

                      // Show the CupertinoDatePicker at the bottom of the screen
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppDimensions.mediumXL.vSpace(),
                              'Select Date'.titleBold(size: 18.sp),
                              AppDimensions.smallXL.vSpace(),
                              // CupertinoDatePicker
                              SizedBox(
                                height: 200,
                                child: CupertinoDatePicker(
                                  initialDateTime: DateTime.now().add(const Duration(days: 5)),
                                  minimumDate: DateTime.now().add(const Duration(days: 4)),
                                  maximumDate: DateTime.now().add(const Duration(days: 365)),
                                  // Limit to one year from today
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (DateTime date) {
                                    // Store the selected date
                                    selectedDate = date;
                                  },
                                ),
                              ),
                              // OK and Cancel buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ButtonWidget(
                                      isValid: true,
                                      buttonBackgroundColor: AppColors.cancelButtonBgColor,
                                      title: 'Cancel',
                                      onPressed: () {
                                        Navigator.pop(context); // Close the bottom sheet without selecting a date
                                      },
                                    ).symmetricPadding(horizontal: 10),
                                  ),
                                  Expanded(
                                    child: ButtonWidget(
                                      title: 'Ok',
                                      isValid: true,
                                      onPressed: () {
                                        // Handle OK button press

                                        // Calculate the difference in days between today and the selected date
                                        customDays = selectedDate.difference(DateTime.now()).inDays + 1;

                                        // Assign the difference to validatorController.text
                                        validatorController.text = value.toString();
                                        // Dispatch event to the bloc
                                        context.read<SharedDocVcBloc>().add(
                                              ShareDocVcUpdatedEvent(selectedItem: value ?? 4),
                                            );

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
                    },
                  ),
                )
              ],
            ).singleSidePadding(left: 10),
            10.verticalSpace,
            ButtonWidget(
                isValid: remarksValue.isNotEmpty ? true : false,
                title: state is SharedLoaderState
                    ? "Please wait..."
                    : remarksValue.isNotEmpty
                        ? 'Continue'
                        : 'Share Document',
                fontSize: 12.sp,
                buttonBackgroundColor: remarksValue.isNotEmpty ? AppColors.blue1E88E5 : AppColors.cancelButtonBgColor,
                onPressed: () {
                  if (state is SharedLoaderState) {
                    return;
                  }
                  List<String> vc = [];
                  if (widget.documentVcData != null) {
                    vc.add(widget.documentVcData!.id);
                  } else {
                    for (DocumentVcData selectedDocs in widget.docsList!) {
                      vc.add(selectedDocs.id);
                    }
                  }
                  if (kDebugMode) {
                    print("selectedValidity  ${validatorController.text}");
                  }

                  var body = json.encode({
                    "certificateType":
                        widget.documentVcData != null ? widget.documentVcData!.category : widget.docsList![0].category,
                    "remarks": controller.text,
                    "restrictions": {
                      "expiresIn": getHoursAccordingToDaySelection(int.parse(validatorController.text)),
                      "viewOnce": int.parse(validatorController.text) == 1 ? true : false
                    }
                  });

                  context.read<SharedDocVcBloc>().add(ShareVcSubmittedEvent(vcIds: vc, request: body));
                }).symmetricPadding(horizontal: AppDimensions.medium),
            AppDimensions.medium.vSpace()
          ]),
        ),
      );
    }));
  }

  int getHoursAccordingToDaySelection(int expiresIn) {
    if (expiresIn == 1) {
      return 7 * 24;
    } else if (expiresIn == 2 || expiresIn == 3) {
      return AppUtils.getHoursAccordingToDaySelection(int.parse(validatorController.text));
    } else {
      return customDays * 24;
    }
  }

  void askForMPINDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EnterMPinDialog(
            title: 'Enter MPIN',
            isCrossIconVisible: true,
            onConfirmPressed: () {
              AppUtils.shareFile('Sharing HSC Marksheet');
            },
          );
        });
  }
}
