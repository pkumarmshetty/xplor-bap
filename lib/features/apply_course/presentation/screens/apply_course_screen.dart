import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../config/routes/path_routing.dart';
import '../blocs/apply_course_bloc.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../../wallet/presentation/blocs/wallet_vc_bloc/wallet_vc_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../core/api_constants.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../widgets/add_document_widget.dart';

class ApplyCourseScreen extends StatefulWidget {
  const ApplyCourseScreen({super.key});

  @override
  State<ApplyCourseScreen> createState() => _ApplyCourseScreenState();
}

class _ApplyCourseScreenState extends State<ApplyCourseScreen> {
  late WebViewController webViewController;

  @override
  void initState() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            AppUtils.printLogs('onPageStarted url: $url');
          },
          onPageFinished: (String url) {
            AppUtils.printLogs('onPageFinished url: $url');
            if (url.startsWith(applyFormSubmit)) {
              context
                  .read<ApplyCourseBloc>()
                  .add(const FormSubmitSuccessfully());
            }
          },
          onWebResourceError: (WebResourceError error) {
            AppUtils.printLogs('onWebResourceError: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            AppUtils.printLogs("OnNavREquestUrl $request");
            AppUtils.printLogs("OnNavREquestUrl safdfssafsa ${request.url}");
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(context.read<ApplyCourseBloc>().url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApplyCourseBloc, ApplyCourseState>(
      listener: (context, state) {
        if (state is CourseDocumentState && state.linkCopied) {
          AppUtils.linkGeneratedDialog(
              context,
              WalletKeys.linkGeneratedTitle.stringToString,
              WalletKeys.linkGeneratedDescription.stringToString,
              WalletKeys.gotIt.stringToString, onConfirm: () {
            context.read<ApplyCourseBloc>().add(const FormSubmitSuccessfully());
            Navigator.pop(context);
          });
        }
        if (state is CourseFailureState) {
          AppUtils.showSnackBar(context, state.errorMessage);
        }
        if (state is NavigationSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.thanksForApplying,
            (routes) => false,
          );
        }
      },
      child: BlocBuilder<ApplyCourseBloc, ApplyCourseState>(
        builder: (context, state) {
          return PopScope(
              onPopInvokedWithResult: (val, result) {
                context.read<WalletVcBloc>().flowType = FlowType.document;
                context
                    .read<ApplyCourseBloc>()
                    .add(const CourseDocumentRemovedEvent());
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: AppBackgroundDecoration(
                      child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTopHeader(
                              title:
                                  SeekerHomeKeys.applicationForm.stringToString,
                              onBackButtonPressed: () {
                                context.read<WalletVcBloc>().flowType =
                                    FlowType.document;
                                context
                                    .read<ApplyCourseBloc>()
                                    .add(const CourseDocumentRemovedEvent());
                                Navigator.pop(context);
                              }),
                          AppDimensions.mediumXL.verticalSpace,
                          Expanded(
                            child: Card(
                              elevation: AppDimensions.extraSmall.w,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimensions.medium.w),
                              ),
                              color: AppColors.white,
                              surfaceTintColor: AppColors.white,
                              child: WebViewWidget(
                                controller: webViewController,
                              ),
                            ).symmetricPadding(
                                horizontal: AppDimensions.smallXL.w),
                          ),
                          AppDimensions.mediumXL.verticalSpace,
                          SeekerHomeKeys.selectFile.stringToString
                              .titleMedium(
                                  size: 14.sp, color: AppColors.grey6469)
                              .symmetricPadding(
                                  horizontal: AppDimensions.medium.w),
                          // state is CourseDocumentState && state.docs.isNotEmpty
                          // ?
/*
              Container(height: 58.w,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(AppDimensions.small),
                        border: Border.all(
                            width: 1, color: AppColors.grey100),
                        color: AppColors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.grey100,
                            offset: Offset(0, 10),
                            blurRadius: 30,
                          )
                        ]),
                    child: Row(
                      children: [
                        AppDimensions.small.w.horizontalSpace,
                        SvgPicture.asset(
                          AppUtils.loadThumbnailBasedOnMimeTime(
                              state.docs[0].fileType
                                  ?.contains('pdf') ?? true
                                  ? 'application/pdf'
                                  : state.docs[0].fileType
                                  ?.contains('png') ?? true
                                  ? 'image/png'
                                  : ''),
                          height: 32.w,
                          width: AppDimensions.large,
                        ),
                        AppDimensions.smallXL.w.horizontalSpace,
                        Expanded(
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.docs[0].name
                                  .titleBoldWithDots(
                                  size: 12.sp, maxLine: 1),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              context
                                  .read<ApplyCourseBloc>()
                                  .add(const CourseDocumentRemovedEvent());
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: SvgPicture.asset(Assets.images.cross)
                                  .paddingAll(
                                padding: AppDimensions.mediumXL,
                              ),
                            )),
                      ],
                    ),
                  ).symmetricPadding(horizontal: AppDimensions.smallXL.w,vertical: AppDimensions.small.w)
*/
                          const AddDocumentWidget(),
                          _applyNowButton(),
                          AppDimensions.mediumXL.verticalSpace
                        ],
                      ),
                      if (state is ApplyFormLoaderState)
                        const LoadingAnimation(),
                    ],
                  )),
                ),
              ));
        },
      ),
    );
  }

  Widget _applyNowButton() {
    return BlocBuilder<ApplyCourseBloc, ApplyCourseState>(
        builder: (context, states) {
      return ButtonWidget(
        title: states is ApplyFormLoaderState
            ? SeekerHomeKeys.plsWait.stringToString
            : SeekerHomeKeys.applyNow.stringToString,
        isValid: context.read<ApplyCourseBloc>().linkCopied,
        onPressed: () {
          if (states is ApplyFormLoaderState) {
            return;
          }
          context.read<ApplyCourseBloc>().add(const CourseConfirmEvent());
        },
      ).symmetricPadding(
          horizontal: AppDimensions.medium, vertical: AppDimensions.smallXL.w);
    });
  }
}
