import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../apply_course/presentation/blocs/apply_course_bloc.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../blocs/wallet_vc_bloc/wallet_vc_event.dart';
import '../widgets/date_picker_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/custom_text_form_fields.dart';
import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/build_button.dart';
import '../blocs/share_doc_vc_bloc/share_doc_vc_bloc.dart';
import '../widgets/share_doc_file_info_widget.dart';
import '../widgets/share_doc_selection_widget.dart';

class ShareDocumentScreen extends StatefulWidget {
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
                    onBackButtonPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                      child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShareDocFileInfoWidget(),
                          AppDimensions.mediumXL.verticalSpace,
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
                          WalletKeys.validity.stringToString
                              .titleBold(size: AppDimensions.smallXXL.sp, color: AppColors.grey64697a),
                          AppDimensions.small.verticalSpace,
                          ShareDocSelectionWidget(
                            onTap: () => context
                                .read<SharedDocVcBloc>()
                                .add(ShareDocVcUpdatedEvent(validity: Validity.once, remarks: remarksValue)),
                            title: WalletKeys.onceOnly,
                            validity: Validity.once,
                          ),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          ShareDocSelectionWidget(
                            onTap: () => context
                                .read<SharedDocVcBloc>()
                                .add(ShareDocVcUpdatedEvent(validity: Validity.oneDay, remarks: remarksValue)),
                            title: WalletKeys.oneDay,
                            validity: Validity.oneDay,
                          ),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          ShareDocSelectionWidget(
                            onTap: () => context
                                .read<SharedDocVcBloc>()
                                .add(ShareDocVcUpdatedEvent(validity: Validity.threeDays, remarks: remarksValue)),
                            title: WalletKeys.threeDays,
                            validity: Validity.threeDays,
                          ),
                          AppDimensions.extraExtraSmall.verticalSpace,
                          InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                customDaysSelected = true;
                                _showDatePicker(4);
                              },
                              child: Card(
                                color: AppColors.white,
                                margin: EdgeInsets.only(bottom: 10.w),
                                surfaceTintColor: Colors.white.withOpacity(0.62),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppDimensions.medium.w),
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
                                            height: AppDimensions.mediumXL.w,
                                            width: AppDimensions.mediumXL.w,
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
                                            ? '$customDays ${WalletKeys.days.stringToString}'.titleRegular(
                                                size: AppDimensions.smallXXL.sp, color: AppColors.grey64697a)
                                            : WalletKeys.customDaysString.stringToString.titleRegular(
                                                size: AppDimensions.smallXXL.sp, color: AppColors.grey64697a)),
                                  ],
                                ).paddingAll(padding: AppDimensions.medium.w),
                              ))
                        ],
                      ).symmetricPadding(horizontal: AppDimensions.medium.w, vertical: AppDimensions.extraSmall.w),
                    ],
                  )),
                  AppDimensions.extraSmall.verticalSpace,
                  ButtonWidget(
                      isValid: state.inputText.isNotEmpty,
                      customText: Row(
                        children: [
                          const Spacer(),
                          state.shareState == ShareState.loading
                              ? WalletKeys.pleaseWait.stringToString
                                  .titleBold(color: AppColors.white, size: AppDimensions.smallXXL.sp)
                              : WalletKeys.shareDocument.stringToString
                                  .titleBold(color: AppColors.white, size: AppDimensions.smallXXL.sp),
                          AppDimensions.small.w.horizontalSpace,
                          const Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.white,
                            size: AppDimensions.medium,
                          ),
                          const Spacer()
                        ],
                      ),
                      onPressed: () {
                        if (state.shareState == ShareState.loading) {
                          return;
                        }
                        var isMpinGenerated = sl<SharedPreferencesHelper>().getBoolean(PrefConstKeys.isMpinCreated);
                        isMpinGenerated
                            ? AppUtilsDialogMixin.askForMPINDialog(context)
                            : Navigator.pushNamed(context, Routes.mpin);
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

              context.read<SharedDocVcBloc>().validity = validatorController.text;
              context.read<SharedDocVcBloc>().customDays = customDays;
              context
                  .read<SharedDocVcBloc>()
                  .add(ShareDocVcUpdatedEvent(validity: Validity.customDays, remarks: remarksValue));

              Navigator.pop(context); // Close the bottom sheet after selecting date
            });
      },
    );
  }
}
