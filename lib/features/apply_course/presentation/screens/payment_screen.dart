import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/extensions/string_to_string.dart';
import '../../../../core/api_constants.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_utils/app_utils.dart';
import '../../../../utils/custom_confirmation_dialog.dart';
import '../../../../utils/widgets/loading_animation.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../blocs/apply_course_bloc.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.paymentUrl});

  final String paymentUrl;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController? controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            AppUtils.printLogs("page started");
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            AppUtils.printLogs("page finished");
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            AppUtils.printLogs("NavigationRequest  ${request.url} ");
            if (request.url.startsWith(successNavigation)) {
              final uri = Uri.parse(request.url);

              // Extract the query parameter
              final razorpayPaymentLinkStatus =
                  uri.queryParameters['razorpay_payment_link_status'];

              if (razorpayPaymentLinkStatus != null &&
                  razorpayPaymentLinkStatus == "paid") {
                Navigator.pop(context);
                _showKYCConfirmationDialog(context);
              } else {
                Navigator.pop(context);
                _showKYCFailDialog(context);
              }

              return NavigationDecision.navigate;
            }

            if (request.url.startsWith(failedNavigation)) {
              final uri = Uri.parse(request.url);

              // Extract the query parameter
              final failedStatus = uri.queryParameters['status'];

              if (failedStatus == 'failed') {
                Navigator.pop(context);
                _showKYCFailDialog(context);
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (val, result) async {
          if (val) {
            return;
          }
          AppUtils.showPaymentAlertDialog(context, () {
            Navigator.of(context).pop();
            if (mounted) {
              Navigator.pop(context);
            }
          });
        },
        child: Scaffold(body: _bodyView()));
  }

  /// Commented for future reference
  /*_appBarView() {
    return CommonTopHeader(
        title: SeekerHomeKeys.payment.stringToString,
        onBackButtonPressed: () {});
  }*/

  _bodyView() {
    return SafeArea(
      child: Stack(
        children: [
          WebViewWidget(controller: controller!),
          if (isLoading) const LoadingAnimation()
        ],
      ),
    );
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopScope(
              canPop: false,
              child: CustomConfirmationDialog(
                title: SeekerHomeKeys.paymentSuccessful.stringToString
                    .titleExtraBold(
                  color: AppColors.countryCodeColor,
                  size: 20.sp,
                ),
                message: SeekerHomeKeys.paymentFullyVerified.stringToString
                    .titleRegular(
                        size: 14.sp,
                        color: AppColors.grey64697a,
                        align: TextAlign.center),
                onConfirmPressed: () {
                  Navigator.of(context).pop();

                  context
                      .read<ApplyCourseBloc>()
                      .add(const CourseConfirmEvent());
                },
                assetPath: Assets.images.icKycSuccess,
              ));
        });
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCFailDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: CustomConfirmationDialog(
            title: SeekerHomeKeys.paymentUnsuccessful.stringToString
                .titleExtraBold(
              color: AppColors.countryCodeColor,
              size: 20.sp,
            ),
            buttonTitle: SeekerHomeKeys.tryAgain.stringToString,
            message: SeekerHomeKeys.paymentFailedMessage.stringToString
                .titleRegular(
                    size: 14.sp,
                    color: AppColors.grey64697a,
                    align: TextAlign.center),
            onConfirmPressed: () {
              // Implement the action when OK button is pressed
              Navigator.of(context).pop(); // Close the dialog
            },
            assetPath: Assets.images.icKycFail,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller!.clearLocalStorage();
    controller!.clearCache();
    super.dispose();
  }
}
