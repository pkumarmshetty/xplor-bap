import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as obj;

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
    _selectFileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddDocumentsBloc, AddDocumentsState>(
        listener: (context, state) {},
        child: BlocBuilder<AddDocumentsBloc, AddDocumentsState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state is FileSelectedState || _selectFileController.text.isNotEmpty || state is FileSelectedErrorState
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColors.hintColor,
                              width: 1.w,
                            ),
                            borderRadius: BorderRadius.circular(AppDimensions.small),
                          ),
                          child: Row(
                            children: [
                              AppDimensions.small.hSpace(),
                              _selectFileController.text.isNotEmpty
                                  ? SvgPicture.asset(
                                      AppUtils.loadThumbnailBasedOnMimeTime(_selectFileController.text.contains('pdf')
                                          ? 'application/pdf'
                                          : _selectFileController.text.contains('png')
                                              ? 'image/png'
                                              : ''),
                                      height: 32.w,
                                      width: 24.w,
                                    )
                                  : Container(),
                              8.hSpace(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _selectFileController.text.titleBoldWithDots(size: 12.sp, maxLine: 1),
                                    AppDimensions.extraSmall.hSpace(),
                                    fileSize.titleRegular(
                                      size: 10.sp,
                                      color: AppColors.hintColor,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _selectFileController.clear();
                                    context.read<AddDocumentsBloc>().add(FileChooseEvent());
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    child: SvgPicture.asset(Assets.images.cross).paddingAll(
                                      padding: AppDimensions.mediumXL,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        if (fileSizeError)
                          Column(
                            children: [
                              "File size should be less than 10 MB"
                                  .titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                              AppDimensions.smallXL.vSpace(),
                            ],
                          ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        'Select File'.titleBold(size: 14.sp),
                        AppDimensions.small.vSpace(),
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
                                _selectFileController.text = obj.basename(file.path);
                                int fileSizeInBytes = file.lengthSync();
                                (fileSizeInBytes > 1024 * 1024)
                                    ? fileSize = '${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB'
                                    : fileSize = '${(fileSizeInBytes / 1024).toStringAsFixed(2)} KB';
                                if (file.lengthSync() > 10 * 1024 * 1024) {
                                  fileSizeError = true;
                                  context.read<AddDocumentsBloc>().add(FileSelectedEvent(
                                        file: file,
                                        iconUrl: Assets.images.pdf,
                                      ));
                                } else {
                                  fileSizeError = false;
                                  context.read<AddDocumentsBloc>().add(FileSelectedEvent(
                                        file: file,
                                        iconUrl: Assets.images.pdf,
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
                                  10.85.vSpace(),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        'Choose '.textSpanSemiBold(),
                                        'file to upload'.textSpanRegular(fontWeight: FontWeight.w600),
                                      ],
                                    ),
                                  ),
                                  AppDimensions.extraSmall.vSpace(),
                                  'Select image,pdf'.titleRegular(size: 12.sp),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (state is FileSelectedErrorState && state.message!.isNotEmpty)
                          Column(
                            children: [
                              state.message.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                              AppDimensions.smallXL.vSpace(),
                            ],
                          ),
                      ],
                    ),
              AppDimensions.smallXL.vSpace(),
              CustomTextFormField(
                label: 'File Name',
                hintText: 'Enter File Name',
                onChanged: (fileName) => context.read<AddDocumentsBloc>().add(FileNameEvent(fileName: fileName)),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                ],
              ),
              if (state is FileNameErrorState && state.message!.isNotEmpty)
                Column(
                  children: [
                    state.message.toString().titleSemiBold(size: 12.sp, color: AppColors.errorColor),
                    AppDimensions.smallXL.vSpace(),
                  ],
                ),
            ],
          );
        }));
  }
}
