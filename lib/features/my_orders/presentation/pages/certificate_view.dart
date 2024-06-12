import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xplor/utils/app_utils/app_utils.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/common_top_header.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../multi_lang/domain/mappers/profile/profile_keys.dart';
import '../blocs/certificate_bloc/cerificate_bloc.dart';
import '../blocs/certificate_bloc/certificate_state.dart';

class CertificateView extends StatefulWidget {
  const CertificateView({super.key, required this.certificateUrl});

  final String certificateUrl;

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  late WebViewController webViewController;
  bool isLoading = true;

  /*Future<void> _checkAndRequestPermissions() async {
    if (await _isStoragePermissionGranted()) {
      debugPrint('Storage permission is already granted.');
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
      debugPrint('Standard storage permission granted.');
      return;
    }

    // Request media permissions for Android 13+
    var photosStatus = await Permission.photos.request();
    var videosStatus = await Permission.videos.request();
    var audioStatus = await Permission.audio.request();

    if (photosStatus.isGranted || videosStatus.isGranted || audioStatus.isGranted) {
      debugPrint('Media permissions granted.');
      return;
    }

    // Request manage external storage permission as a fallback
    var manageStatus = await Permission.manageExternalStorage.request();
    if (manageStatus.isGranted) {
      debugPrint('Manage external storage permission granted.');
    } else {
      debugPrint('All requested permissions denied.');
    }
  }*/

  @override
  void initState() {
    // _checkAndRequestPermissions();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            debugPrint("page started");
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            debugPrint("page finished");
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
      ..loadRequest(Uri.parse(widget.certificateUrl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackgroundDecoration(
          child: BlocListener<DownloadBloc, DownloadState>(
        listener: (context, state) {
          if (state is DownloadSuccess) {
            AppUtils.showSnackBar(context, ProfileKeys.fileDownloadedSuccessfully.stringToString,
                bgColor: AppColors.primaryColor);
          }
          if (state is DownloadFailure) {
            AppUtils.showSnackBar(context, '${ProfileKeys.downloadFailed.stringToString}: ${state.error}',
                bgColor: AppColors.primaryColor);
          }
        },
        child: BlocBuilder<DownloadBloc, DownloadState>(builder: (context, state) {
          return Stack(children: [
            Column(
              children: [
                CommonTopHeader(
                  title: ProfileKeys.certificate.stringToString,
                  onBackButtonPressed: () => Navigator.pop(context),
                ),
                AppDimensions.medium.vSpace(),
                Expanded(
                  child: Card(
                    elevation: AppDimensions.extraSmall.w,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.w),
                    ),
                    color: AppColors.white,
                    surfaceTintColor: AppColors.white,
                    child: WebViewWidget(controller: webViewController),
                  ).symmetricPadding(horizontal: AppDimensions.smallXL.w),
                ),
                AppDimensions.medium.vSpace(),
                /*ButtonWidget(
                title: ProfileKeys.addToWallet.stringToString,
                onPressed: () {},
                isValid: true,
              ).symmetricPadding(horizontal: AppDimensions.smallXL.w),
              AppDimensions.small.vSpace(),*/
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
                AppDimensions.medium.vSpace(),*/
              ],
            ),
            if (isLoading) const LoadingAnimation()
          ]);
        }),
      )),
    );
  }
}
