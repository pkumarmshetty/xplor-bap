import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xplor/features/my_orders/domain/entities/certificate_view_arguments.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/app_background_widget.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/widgets/build_button.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../../../multi_lang/domain/mappers/wallet/wallet_keys.dart';
import '../blocs/certificate_bloc/cerificate_bloc.dart';
import '../blocs/certificate_bloc/certificate_event.dart';
import '../blocs/certificate_bloc/certificate_state.dart';
import '../blocs/my_orders_bloc/my_orders_bloc.dart';
import '../blocs/my_orders_bloc/my_orders_event.dart';

/// Certificate View.
class CertificateView extends StatefulWidget {
  const CertificateView({super.key, this.arguments});
  final CertificateViewArguments? arguments;

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  late WebViewController webViewController;
  bool isLoading = true;

  /*Future<void> _checkAndRequestPermissions() async {
    if (await _isStoragePermissionGranted()) {
      AppUtils.printLogs('Storage permission is already granted.');
    } else {
      await _requestStoragePermissions();
    }
  }

  Future<bool> _isStoragePermissionGranted() async {
    if (await Permission.storage.isGranted) {
      return true;
    }

    // Check for media permissions on Android 13+
    if (await Permission.photos.isGranted || await Permission.videos.isGranted || await Permission.audio.isGranted) {
      return true;
    }

    // Check for manage external storage permission
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    return false;
  }

  Future<void> _requestStoragePermissions() async {
    // Request the standard storage permission
    var storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      AppUtils.printLogs('Standard storage permission granted.');
      return;
    }

    // Request media permissions for Android 13+
    var photosStatus = await Permission.photos.request();
    var videosStatus = await Permission.videos.request();
    var audioStatus = await Permission.audio.request();

    if (photosStatus.isGranted || videosStatus.isGranted || audioStatus.isGranted) {
      AppUtils.printLogs('Media permissions granted.');
      return;
    }

    // Request manage external storage permission as a fallback
    var manageStatus = await Permission.manageExternalStorage.request();
    if (manageStatus.isGranted) {
      AppUtils.printLogs('Manage external storage permission granted.');
    } else {
      AppUtils.printLogs('All requested permissions denied.');
    }
  }*/

  /// Init State
  @override
  void initState() {
    // _checkAndRequestPermissions();
    context.read<CertificateBloc>().add(CertificateInitial());
    AppUtils.printLogs(
        "Certificate URL...  ${widget.arguments?.certificateUrl}");
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            AppUtils.printLogs("page started");
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            AppUtils.printLogs("page finished");
            setState(() {
              isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.arguments!.certificateUrl));
    super.initState();
  }

  /// Widget tree
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (val, result) {
        _callOrderApi();
      },
      child: Scaffold(
        body: AppBackgroundDecoration(
            child: BlocListener<CertificateBloc, CertificateState>(
          listener: (context, state) {
            /// Download success and failure
            if (state is DownloadSuccess) {
              AppUtils.showSnackBar(context,
                  ProfileKeys.fileDownloadedSuccessfully.stringToString,
                  bgColor: AppColors.primaryColor);
            }
            if (state is DownloadFailure) {
              AppUtils.showSnackBar(context,
                  '${ProfileKeys.downloadFailed.stringToString}: ${state.error}',
                  bgColor: AppColors.errorColor);
            }
            if (state is DocumentUploadSuccessState) {
              AppUtils.showSnackBar(
                  context, WalletKeys.documentUploaded.stringToString,
                  bgColor: AppColors.primaryColor);
            }
            if (state is DocumentUploadFailureState) {
              AppUtils.showSnackBar(context,
                  '${ProfileKeys.uploadFailed.stringToString}: ${state.error}',
                  bgColor: AppColors.errorColor);
            }
          },
          child: BlocBuilder<CertificateBloc, CertificateState>(
              builder: (context, state) {
            return Stack(children: [
              Column(
                children: [
                  CommonTopHeader(
                    title: ProfileKeys.certificate.stringToString,
                    onBackButtonPressed: () => Navigator.pop(context),
                  ),
                  AppDimensions.medium.verticalSpace,
                  Expanded(
                    child: Card(
                      elevation: AppDimensions.extraSmall.w,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.medium.w),
                      ),
                      color: AppColors.white,
                      surfaceTintColor: AppColors.white,
                      child: WebViewWidget(controller: webViewController),
                    ).symmetricPadding(horizontal: AppDimensions.smallXL.w),
                  ),
                  AppDimensions.medium.verticalSpace,
                  (widget.arguments?.ordersEntity.isAddedToWallet == false &&
                          state is! DocumentUploadSuccessState)
                      ? Column(
                          children: [
                            ButtonWidget(
                              title: ProfileKeys.addToWallet.stringToString,
                              onPressed: () {
                                context.read<CertificateBloc>().add(
                                    AddCertificateToWallet(
                                        widget.arguments?.certificateUrl,
                                        widget.arguments?.ordersEntity));
                              },
                              isValid: true,
                            ).symmetricPadding(
                                horizontal: AppDimensions.smallXL.w),
                            AppDimensions.small.verticalSpace,
                          ],
                        )
                      : const SizedBox()

                  /*ButtonWidget(
                  title: ProfileKeys.addToWallet.stringToString,
                  onPressed: () {},
                  isValid: true,
                ).symmetricPadding(horizontal: AppDimensions.smallXL.w),
                AppDimensions.small.verticalSpace,*/
                  /* ButtonWidget(
                    onPressed: () {
                      context.read<DownloadBloc>().add(StartDownload(
                          widget.certificateUrl, 'certificate.pdf'));
                    },
                    isValid: true,
                    isFilled: false,
                    customText: state is DownloadInProgress
                        ? '${ProfileKeys.downloading.stringToString} (${state.progress * 100}%)'
                            .titleBold(
                            size: 14.sp,
                            color: AppColors.primaryColor,
                          )
                        : ProfileKeys.downloadCertificate.stringToString
                            .titleBold(
                            size: 14.sp,
                            color: AppColors.primaryColor,
                          ),
                  ).symmetricPadding(horizontal: AppDimensions.smallXL.w),
                  AppDimensions.medium.verticalSpace,*/
                ],
              ),
              if (isLoading || state is UploadDocumentLoadingState)
                const LoadingAnimation()
            ]);
          }),
        )),
      ),
    );
  }

  /// Calls the order api.
  void _callOrderApi() {
    context
        .read<MyOrdersBloc>()
        .add(const MyOrdersDataEvent(isFirstTime: true));
    context
        .read<MyOrdersBloc>()
        .add(const MyOrdersCompletedEvent(isFirstTime: true));
  }
}
