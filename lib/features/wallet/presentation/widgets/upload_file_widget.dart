import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as obj;
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/custom_text_form_fields.dart';
import '../blocs/add_document_bloc/add_document_bloc.dart';
import '../blocs/add_document_bloc/add_document_event.dart';
import '../blocs/add_document_bloc/add_document_state.dart';

/// A widget that allows users to upload files.
///
/// The `UploadFileWidget` class provides an interface for selecting and uploading files.
class UploadFileWidget extends StatefulWidget {
  const UploadFileWidget({super.key});

  @override
  State<UploadFileWidget> createState() => _UploadFileWidgetState();
}

class _UploadFileWidgetState extends State<UploadFileWidget> {
  final TextEditingController _selectFileController = TextEditingController();
  String fileSize = '0.0KB';
  bool fileSizeError = false;

  @override
  void dispose() {
    super.dispose();
    _selectFileController.dispose(); // Dispose the controller when the widget is removed
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddDocumentsBloc, AddDocumentsState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Align content to the start
        children: [
          // Check if a file is selected or an error occurred
          state is FileSelectedState || _selectFileController.text.isNotEmpty || state is FileSelectedErrorState
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the selected file details
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      // Padding inside the container
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.small),
                        // Rounded corners
                        border: Border.all(width: 1, color: AppColors.grey100),
                        // Border styling
                        color: AppColors.white,
                        // Background color
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.grey100, // Shadow color
                            offset: Offset(0, 10), // Offset for the shadow
                            blurRadius: 30, // Blur radius for the shadow
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          AppDimensions.small.w.horizontalSpace, // Horizontal space
                          _selectFileController.text.isNotEmpty
                              ? SvgPicture.asset(
                                  AppUtils.loadThumbnailBasedOnMimeTime(_selectFileController.text.contains('pdf')
                                      ? 'application/pdf' // Determine the file type for thumbnail
                                      : _selectFileController.text.contains('png')
                                          ? 'image/png'
                                          : ''),
                                  height: AppDimensions.xxl.w, // Thumbnail height
                                  width: AppDimensions.large.w, // Thumbnail width
                                )
                              : Container(),
                          AppDimensions.smallXL.w.horizontalSpace, // Horizontal space
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display the file name
                                _selectFileController.text
                                    .titleBoldWithDots(size: AppDimensions.smallXL.sp, maxLine: 1),
                                AppDimensions.extraSmall.w.horizontalSpace,
                                // Display the file size
                                fileSize.titleRegular(
                                  size: 10.sp,
                                  color: AppColors.hintColor,
                                ),
                              ],
                            ),
                          ),
                          // Remove the selected file
                          GestureDetector(
                            onTap: () {
                              _selectFileController.clear(); // Clear the file input
                              context.read<AddDocumentsBloc>().add(FileChooseEvent()); // Trigger file choose event
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: SvgPicture.asset(Assets.images.cross).paddingAll(
                                padding: AppDimensions.mediumXL,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Display an error message if the file size is too large
                    if (fileSizeError)
                      Column(
                        children: [
                          WalletKeys.fileSizeShouldBeLess.stringToString
                              .titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                          AppDimensions.smallXL.verticalSpace,
                        ],
                      ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display a prompt to select a file
                    WalletKeys.selectFile.stringToString.titleBold(size: 14.sp, color: AppColors.grey64697a),
                    AppDimensions.small.verticalSpace,
                    // Dotted border for the file upload area
                    DottedBorder(
                      color: state is FileSelectedErrorState ? AppColors.errorColor : AppColors.hintColor,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(AppDimensions.smallXL.r),
                      padding: const EdgeInsets.all(6),
                      dashPattern: const [
                        AppDimensions.extraSmall,
                        AppDimensions.extraSmall,
                      ],
                      child: GestureDetector(
                        onTap: () => AppUtils.chooseFileDialog(getMediaData: (file) async {
                          if (file != null) {
                            Navigator.pop(context);
                            _selectFileController.text = obj.basename(file.path); // Set the file name
                            int fileSizeInBytes = file.lengthSync();
                            (fileSizeInBytes > 1024 * 1024)
                                ? fileSize =
                                    '${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB' // Calculate file size in MB
                                : fileSize =
                                    '${(fileSizeInBytes / 1024).toStringAsFixed(2)} KB'; // Calculate file size in KB
                            if (file.lengthSync() > 10 * 1024 * 1024) {
                              fileSizeError = true; // Set error flag if file size exceeds 10MB
                              context.read<AddDocumentsBloc>().add(FileSelectedEvent(
                                    file: file,
                                    iconUrl: Assets.images.pdf, // Use PDF icon
                                  ));
                            } else {
                              fileSizeError = false; // Clear error flag
                              context.read<AddDocumentsBloc>().add(FileSelectedEvent(
                                    file: file,
                                    iconUrl: Assets.images.pdf, // Use PDF icon
                                  ));
                            }
                          }
                        }),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppDimensions.mediumXL,
                            horizontal: AppDimensions.large,
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(Assets.images.documentUpload),
                              // Upload icon
                              10.85.verticalSpace,
                              RichText(
                                text: TextSpan(
                                  children: [
                                    // Display text for choosing a file
                                    '${WalletKeys.choose.stringToString} '.textSpanSemiBold(),
                                    WalletKeys.fileToUpload.stringToString.textSpanRegular(fontWeight: FontWeight.w600),
                                  ],
                                ),
                              ),
                              AppDimensions.extraSmall.verticalSpace,
                              // Display accepted file formats and size limit
                              '${WalletKeys.upload.stringToString} jpeg, png, or pdf (max 10MB)'
                                  .titleRegular(size: AppDimensions.smallXL.sp),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Display an error message if there's a file selection error
                    if (state is FileSelectedErrorState && state.message!.isNotEmpty)
                      Column(
                        children: [
                          state.message.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                          AppDimensions.smallXL.verticalSpace,
                        ],
                      ),
                  ],
                ),
          AppDimensions.smallXL.verticalSpace,
          // Text field for entering the file name
          CustomTextFormField(
            label: WalletKeys.fileName.stringToString,
            hintText: WalletKeys.enterFileName.stringToString,
            onChanged: (fileName) => context.read<AddDocumentsBloc>().add(FileNameEvent(fileName: fileName)),
            // Trigger file name event
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              // Restrict input to alphanumeric characters
            ],
          ),
          // Display an error message if there's a file name error
          if (state is FileNameErrorState && state.message!.isNotEmpty)
            Column(
              children: [
                state.message.toString().titleSemiBold(size: AppDimensions.smallXL.sp, color: AppColors.errorColor),
                AppDimensions.smallXL.verticalSpace,
              ],
            ),
        ],
      );
    });
  }
}
