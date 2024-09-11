import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'update_consent_radio_widget.dart';
import 'date_picker_widget.dart';
import 'update_consent_header_widget.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../domain/entities/shared_data_entity.dart';
import '../blocs/update_consent_dialog_bloc/update_consent_dialog_bloc.dart';
import '../blocs/update_consent_dialog_bloc/update_consent_dialog_state.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/top_header_for_dialogs.dart';
import '../../domain/entities/update_consent_entity.dart';
import '../blocs/my_consent_bloc/my_consent_bloc.dart';
import '../blocs/my_consent_bloc/my_consent_event.dart';
import '../blocs/update_consent_dialog_bloc/update_consent_dialog_event.dart';

/// Update Consent Dialog Widget
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
          validatorController.text = "2";

        case 72:
          validatorController.text = "3";

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
            UpdateConsentHeaderWidget(
              entity: widget.entity,
              remarksController: remarksController,
              onChanged: (data) {
                remarksValue = data;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(
                    remarks: data, selectedItem: (state as ConsentUpdateDialogUpdatedState).selectedItem));
              },
            ),
            UpdateConsentRadioWidget(
              title: WalletKeys.onceOnly,
              value: 1,
              groupValue: int.parse(validatorController.text),
              onChanged: (value) {
                validatorController.text = value.toString();
                customDaysSelected = false;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 1));
              },
            ),
            UpdateConsentRadioWidget(
              title: WalletKeys.oneDay,
              value: 2,
              groupValue: int.parse(validatorController.text),
              onChanged: (value) {
                validatorController.text = value.toString();
                customDaysSelected = false;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 2));
              },
            ),
            UpdateConsentRadioWidget(
              value: 3,
              title: WalletKeys.threeDays,
              groupValue: int.parse(validatorController.text),
              onChanged: (value) {
                validatorController.text = value.toString();
                customDaysSelected = false;
                context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 3));
              },
            ),
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
                    19.horizontalSpace,
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
            AppDimensions.medium.verticalSpace
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
        return DatePickerWidget(
          onDateTimeChanged: (DateTime date) {
            // Store the selected date
            setState(() {
              _selectedDate = date;
            });
          },
          selectedDate: _selectedDate,
          onOkPressed: () {
            // Handle OK button press

            // Calculate the difference in days between today and the selected date
            customDays = _selectedDate!.difference(DateTime.now()).inDays + 1;
            setState(() {});

            // Assign the difference to validatorController.text
            validatorController.text = value.toString();
            // Dispatch event to the bloc
            context.read<UpdateConsentDialogBloc>().add(ConsentUpdateDialogUpdatedEvent(selectedItem: value ?? 4));

            Navigator.pop(context); // Close the bottom sheet after selecting date
          },
        );
      },
    );
  }
}
