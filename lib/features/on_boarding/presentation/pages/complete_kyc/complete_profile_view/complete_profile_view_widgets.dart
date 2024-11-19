part of 'complete_profile_view.dart';

Future<void> clearWebViewCache() async {
  try {
    const platform = MethodChannel('com.example.xplor/webview');
    await platform.invokeMethod('clearCache');
  } on PlatformException catch (e) {
    AppUtils.printLogs("Failed to clear cache: '${e.message}'.");
  }
}

Widget completeProfileViewWidget(
    BuildContext context, KycState state, Widget agreeConditionWidget, Function(int) setSelectedIndex) {
  return Stack(children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTopHeader(
            title: OnBoardingKeys.completeProfile.stringToString,
            onBackButtonPressed: () {
              AppUtils.showAlertDialog(context, true);
            }),
        AppDimensions.large.verticalSpace,
        context.read<KycBloc>().entity != null
            ? Expanded(
                child: SingleSelectionWallet(
                    selectedIndex: selectedIndex,
                    onIndexChanged: setSelectedIndex,
                    entity: context.read<KycBloc>().entity!))
            : Container(),
        _bottomViewContent(context, state, agreeConditionWidget)
      ],
    ),
    if (state is KycLoadingState) const LoadingAnimation(),
  ]);
}
