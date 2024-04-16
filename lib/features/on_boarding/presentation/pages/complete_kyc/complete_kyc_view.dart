import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xplor/features/on_boarding/presentation/blocs/kyc_bloc/kyc_bloc.dart';
import 'package:xplor/utils/app_utils.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../../config/routes/path_routing.dart';
import '../../../../../core/api_constants.dart';
import '../../../../../utils/app_colors.dart';

/// Importing necessary paths and services
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/custom_confirmation_dialog.dart';
import '../../../../../utils/custom_dialog_view.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/extensions/padding.dart';
import '../../../../../utils/extensions/space.dart';
import '../../../../../utils/widgets/build_button.dart';
import '../../widgets/build_custom_checkbox.dart';
import '../../widgets/build_single_selection_wallet.dart';
import '../../widgets/build_welcome.dart';

/// Definition of the CompleteKYCView widget
class CompleteKYCView extends StatefulWidget {
  const CompleteKYCView({super.key});

  @override
  State<CompleteKYCView> createState() => _CompleteKYCViewState();
}

/// State class for CompleteKYCView widget
class _CompleteKYCViewState extends State<CompleteKYCView> {
  bool isValid = false;
  bool isChecked = false;
  int selectedIndex = -1;

  /// Method to set the selected index
  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  WebViewController webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(AppColors.white);

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (bool val) {
          AppUtils.showAlertDialog(context);
        },
        child: Scaffold(
            body: SafeArea(
          child: BlocListener<KycBloc, KycState>(listener: (context, state) {
            // show success dialog if KYC verified successfully
            if (state is AuthorizedUserState) {
              _showKYCConfirmationDialog(context);
            } else if (state is EAuthSuccessEvent) {
              _showKYCConfirmationDialog(context);
            }
            // shows the WebView to open the callback from API
            else if (state is ShowWebViewState) {
              webViewController.setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {},
                  onPageStarted: (String url) {
                    if (kDebugMode) {
                      print('onPageStarted $url');
                    }
                  },
                  onPageFinished: (String url) {
                    // Do the task here
                    if (kDebugMode) {
                      print('onPageFinished $url');
                    }
                  },
                  onWebResourceError: (WebResourceError error) {},
                  onNavigationRequest: (NavigationRequest request) {
                    if (kDebugMode) {
                      print('onNavigationRequest ${request.url}');
                    }
                    if (request.url.startsWith(eAuthWebHook)) {
                      context.read<KycBloc>().add(const EAuthSuccessEvent());
                      return NavigationDecision.navigate;
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              );
              webViewController.loadRequest(Uri.parse(state.requestUrl));
            }

            // show failure dialog if KYC verification failed
            else if (state is KycFailedState) {
              _showKYCFailDialog(context);
            }
            // show error snackbar if an error occurred
            else if (state is KycErrorState) {
              AppUtils.showSnackBar(context, state.error);
            }
          }, child: BlocBuilder<KycBloc, KycState>(builder: (context, state) {
            if (state is ShowWebViewState) {
              return Stack(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: WebViewWidget(controller: webViewController))
                ]),
                Positioned(
                    right: AppDimensions.medium,
                    top: AppDimensions.medium,
                    child: GestureDetector(
                      onTap: () {
                        context.read<KycBloc>().add(const CloseEAuthWebView());
                      },
                      child: const Icon(Icons.close, color: AppColors.black),
                    ))
              ]);
            }
            return Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WelcomeContentWidget(
                          title: 'Complete your KYC',
                          subTitle: 'Select one to proceed')
                      .symmetricPadding(
                    horizontal: AppDimensions.large,
                  ),
                  AppDimensions.large.vSpace(),
                  Expanded(
                      child: SingleSelectionWallet(
                    selectedIndex: selectedIndex,
                    onIndexChanged: setSelectedIndex,
                  )),
                  _bottomViewContent(context, state)
                ],
              ),
              if (state is KycLoadingState) const LoadingAnimation(),
            ]);
          })),
        )));
  }

  /// Widget for building the bottom view content
  Widget _bottomViewContent(BuildContext context, KycState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        agreeConditionWidget(),
        AppDimensions.smallXL.vSpace(),
        ButtonWidget(
          title: 'Continue',
          isValid: isValid && selectedIndex != -1,
          onPressed: () {
            context.read<KycBloc>().add(const UpdateUserKycEvent());
            // _authBloc.updateKyc
            //     ? _showKYCConfirmationDialog(context)
            //     : _showKYCFailDialog(context);
          },
        ),
        AppDimensions.mediumXL.vSpace(),
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.large,
    );
  }

  /// Widget for the agree condition
  Widget agreeConditionWidget() {
    return Row(
      children: <Widget>[
        CustomCheckbox(
          onChanged: (isChecked) {
            setState(() {
              isValid = isChecked;
            });
          },
        ),
        AppDimensions.small.hSpace(),
        GestureDetector(
          onTap: () {
            _showConsentDialog(context); // Call method to show dialog
          },
          child: RichText(
            text: TextSpan(
              children: [
                'I hereby confirm my '.textSpanRegular(),
                'consent to authorize'
                    .textSpanSemiBold(decoration: TextDecoration.underline),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Method to show the consent dialog
  void _showConsentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogView(
          title: 'Consent to Authorize',
          message:
              'We are committed to protecting your privacy and ensuring the security of your personal data. We only share minimum necessary data with trusted third parties for authentication purposes, and your data will never be shared for any other purposes without your explicit consent. Your personal data is used solely for providing personalized journeys and recommendations within the application.',
          onConfirmPressed: () {
            // Implement the action when OK button is pressed
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: 'KYC Successful!',
          message: 'You have been successfully verified.'.titleRegular(
              size: 14.sp,
              color: AppColors.alertDialogMessageColor,
              align: TextAlign.center),
          onConfirmPressed: () {
            // Implement the action when OK button is pressed
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false, // Do not allow back navigation
            ); // Close the dialog
          },
          assetPath: 'assets/images/success_icon.svg',
        );
      },
    );
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCFailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: 'KYC Verification Failed!',
          message: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              'Please review your information and documents, ensuring accuracy.'
                  .titleRegular(
                      size: 14.sp,
                      color: AppColors.alertDialogMessageColor,
                      align: TextAlign.center),
              RichText(
                text: TextSpan(
                  children: [
                    'For assistance, '.textSpanRegular(),
                    'contact support.'
                        .textSpanSemiBold(decoration: TextDecoration.underline),
                  ],
                ),
              ),
            ],
          ),
          onConfirmPressed: () {
            // Implement the action when OK button is pressed
            Navigator.of(context).pop(); // Close the dialog
          },
          assetPath: 'assets/images/kyc_fail_icon.svg',
        );
      },
    );
  }
}
