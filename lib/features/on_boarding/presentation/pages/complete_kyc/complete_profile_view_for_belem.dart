import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../multi_lang/domain/mappers/on_boarding/on_boardings_keys.dart';
import '../../../../../utils/extensions/string_to_string.dart';
import '../../../../../utils/utils.dart';
import '../../../../../utils/widgets/loading_animation.dart';
import '../../../../../config/routes/path_routing.dart';
import '../../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../../core/api_constants.dart';
import '../../../../../core/dependency_injection.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_dimensions.dart';
import '../../../../../utils/app_utils/app_utils.dart';
import '../../../../../utils/circluar_button.dart';
import '../../../../../utils/common_top_header.dart';
import '../../../../../utils/custom_confirmation_dialog.dart';
import '../../../../../utils/custom_dialog_view.dart';
import '../../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../../utils/widgets/app_background_widget.dart';
import '../../blocs/kyc_bloc_belem/kyc_bloc_belem.dart';
import '../../widgets/build_custom_checkbox.dart';
import '../../widgets/build_single_selection_wallet.dart';
import '../../widgets/kyc_loader_status.dart';

/// Widget for the sign-in view.
class CompleteProfileViewBelem extends StatefulWidget {
  const CompleteProfileViewBelem({super.key});

  @override
  State<CompleteProfileViewBelem> createState() =>
      _CompleteProfileViewBelemState();
}

/// State class for the sign-in view.
class _CompleteProfileViewBelemState extends State<CompleteProfileViewBelem> {
  bool isValid = false;
  bool isChecked = false;
  int selectedIndex = -1;
  bool loader = false;

  @override
  void initState() {
    context.read<KycBlocBelem>().add(const GetProvidersEvent());
    super.initState();
  }

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
    return BlocBuilder<KycBlocBelem, KycStateBelem>(builder: (context, state) {
      return PopScope(
          canPop: false,
          onPopInvokedWithResult: (val, result) {
            if (state is AuthorizedUserState) {
              return;
            }
            AppUtils.showAlertDialog(context, true);
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: AppBackgroundDecoration(
              child: SafeArea(
                child: BlocListener<KycBlocBelem, KycStateBelem>(
                  listener: (context, state) async {
                    if (state is KycErrorState) {
                      AppUtils.showSnackBar(context, state.error);
                    }
                    // show success dialog if KYC verified successfully
                    if (state is AuthorizedUserState) {
                      _showKYCConfirmationDialog(context);
                    }
                    // shows the WebView to open the callback from API
                    else if (state is ShowWebViewState) {
                      webViewController.setNavigationDelegate(
                        NavigationDelegate(
                          onProgress: (int progress) {},
                          onPageStarted: (String url) {
                            AppUtils.printLogs('onPageStarted $url');
                          },
                          onPageFinished: (String url) {
                            // Do the task here
                            AppUtils.printLogs('onPageFinished $url');
                            loader = false;
                            setState(() {});

                            if (url.startsWith(eAuthWebHook)) {
                              context
                                  .read<KycBlocBelem>()
                                  .add(const InitSseKycEvent());
                              //return NavigationDecision.navigate;
                            }

                            /*if (url.startsWith(eAuthSubmitForm)) {
                              context
                                  .read<KycBlocBelem>()
                                  .add(const ShowKycLoadingEvent());
                              //return NavigationDecision.navigate;
                            }*/
                          },
                          onWebResourceError: (WebResourceError error) {},
                          onNavigationRequest: (NavigationRequest request) {
                            AppUtils.printLogs(
                                'onNavigationRequest ${request.url}');

                            if (request.url.startsWith(eAuthWebHook)) {
                              context
                                  .read<KycBlocBelem>()
                                  .add(const InitSseKycEvent());
                              return NavigationDecision.navigate;
                            }
                            if (request.url.startsWith(eAuthWebHookError)) {
                              context
                                  .read<KycBlocBelem>()
                                  .add(const EAuthFailureEvent());
                              return NavigationDecision.navigate;
                            }
                            return NavigationDecision.navigate;
                          },
                        ),
                      );
                      try {
                        const platform =
                            MethodChannel('com.example.xplor/webview');
                        await platform.invokeMethod('clearCache');
                        /*ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cache cleared")),
                        );*/
                      } on PlatformException catch (e) {
                        AppUtils.printLogs(
                            "Failed to clear cache: '${e.message}'.");
                      }
                      AppUtils.printLogs(
                          "state.requestUrl.trim()... ${state.requestUrl!.trim()}");
                      webViewController
                          .loadRequest(Uri.parse(state.requestUrl!.trim()));
                    }

                    // show failure dialog if KYC verification failed
                    else if (state is KycFailedState) {
                      _showKYCFailDialog(context);
                    }
                  },
                  child: BlocBuilder<KycBlocBelem, KycStateBelem>(
                    builder: (context, state) {
                      if (state is ShowWebViewState ||
                          state is WebLoadingState ||
                          state is KycWebLoadingState ||
                          state is AuthProviderLoadingState) {
                        return Stack(children: [
                          if (state is ShowWebViewState)
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: WebViewWidget(
                                          controller: webViewController))
                                ]),
                          if (state is! KycWebLoadingState &&
                              state is! AuthProviderLoadingState)
                            Positioned(
                                right: AppDimensions.medium,
                                top: AppDimensions.medium,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<KycBlocBelem>()
                                        .add(const CloseEAuthWebView());
                                  },
                                  child: const Icon(Icons.close,
                                      color: AppColors.black),
                                )),
                          if (state is WebLoadingState ||
                              loader ||
                              state is AuthProviderLoadingState)
                            const LoadingAnimation(),
                          if (state is KycWebLoadingState)
                            const KycLoaderWidget()
                        ]);
                      }
                      return Stack(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonTopHeader(
                                title: OnBoardingKeys
                                    .completeProfile.stringToString,
                                onBackButtonPressed: () {
                                  AppUtils.showAlertDialog(context, true);
                                }),
                            AppDimensions.large.verticalSpace,
                            context.read<KycBlocBelem>().entity != null
                                ? Expanded(
                                    child: SingleSelectionWallet(
                                        selectedIndex: selectedIndex,
                                        onIndexChanged: setSelectedIndex,
                                        entity: context
                                            .read<KycBlocBelem>()
                                            .entity!))
                                : Container(),
                            _bottomViewContent(context, state)
                          ],
                        ),
                        //if (state is KycLoadingState) const LoadingAnimation(),
                      ]);
                    },
                  ),
                ),
              ),
            ),
          ));
    });
  }

  /// Widget for building the bottom view content
  Widget _bottomViewContent(BuildContext context, KycStateBelem state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        agreeConditionWidget(),
        AppDimensions.smallXL.verticalSpace,
        CircularButton(
          isValid: isValid && selectedIndex != -1,
          title: OnBoardingKeys.verify.stringToString,
          onPressed: () {
            loader = true;
            context.read<KycBlocBelem>().add(OpenWebViewEvent(
                redirectUrl: sl<SharedPreferencesHelper>()
                    .getString(PrefConstKeys.kycRedirectUrl)));
          },
        ),
        AppDimensions.large.verticalSpace
      ],
    ).symmetricPadding(
      horizontal: AppDimensions.medium,
    );
  }

  /// Widget for the agree condition
  Widget agreeConditionWidget() {
    return Row(
      children: <Widget>[
        CustomCheckbox(
          isChecked: isValid,
          onChanged: (isChecked) {
            setState(() {
              isValid = isChecked;
            });
          },
        ),
        AppDimensions.small.w.horizontalSpace,
        Flexible(
          child: GestureDetector(
            onTap: () {
              _showConsentDialog(context); // Call method to show dialog
            },
            child: RichText(
              text: TextSpan(
                children: [
                  '${OnBoardingKeys.iHereConfirmMy.stringToString} '
                      .textSpanRegular(
                          color: AppColors.alertDialogMessageColor),
                  OnBoardingKeys.consentToAuthorize.stringToString
                      .textSpanSemiBold(decoration: TextDecoration.underline),
                ],
              ),
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
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialogView(
            title: OnBoardingKeys.consentToAuthorizeTitle.stringToString,
            message: OnBoardingKeys.consentToAuthorizeMessage.stringToString,
            onConfirmPressed: () {
              // Implement the action when OK button is pressed
              Navigator.of(context).pop(); // Close the dialog
            },
          );
        });
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCConfirmationDialog(BuildContext context) {
    sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isHomeOpen, true);
    sl<SharedPreferencesHelper>().setBoolean('${PrefConstKeys.kyc}Done', true);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: OnBoardingKeys.kycSuccessful.stringToString.titleExtraBold(
              color: AppColors.countryCodeColor,
              size: 20.sp,
            ),
            message: OnBoardingKeys
                .youHaveBeenSuccessFullyVerified.stringToString
                .titleRegular(
                    size: 14.sp,
                    color: AppColors.grey64697a,
                    align: TextAlign.center),
            onConfirmPressed: () {
              // Implement the action when OK button is pressed
              var role = sl<SharedPreferencesHelper>()
                  .getString(PrefConstKeys.selectedRole);
              var route = role == PrefConstKeys.seekerKey
                  ? Routes.seekerHome
                  : Routes.home;

              if (sl<SharedPreferencesHelper>()
                      .getString(PrefConstKeys.loginFrom) ==
                  PrefConstKeys.seekerHomeKey) {
                //Navigator.pop(context);
                Navigator.pop(context);

                Navigator.of(context).pop();
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  route,
                  (route) => false, // Do not allow back navigation
                );
              } // Close the dialog
            },
            assetPath: Assets.images.icKycSuccess,
          );
        });
  }

  /// Method to show the KYC confirmation dialog
  void _showKYCFailDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomConfirmationDialog(
            title: OnBoardingKeys.kycUnsuccessful.stringToString.titleExtraBold(
              color: AppColors.countryCodeColor,
              size: 20.sp,
            ),
            buttonTitle: OnBoardingKeys.tryAgain.stringToString,
            message: OnBoardingKeys.kycVerificationFailedMessage.stringToString
                .titleRegular(
                    size: 14.sp,
                    color: AppColors.grey64697a,
                    align: TextAlign.center),
            onConfirmPressed: () {
              // Implement the action when OK button is pressed
              Navigator.of(context).pop(); // Close the dialog
            },
            assetPath: Assets.images.icKycFail,
          );
        });
  }

  @override
  void dispose() {
    AppUtils.printLogs("dispose ");
    webViewController.clearCache();
    webViewController.clearLocalStorage();

    super.dispose();
  }
}
