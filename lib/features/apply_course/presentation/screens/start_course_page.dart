import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xplor/features/apply_course/presentation/blocs/apply_course_bloc.dart';
import 'package:xplor/utils/extensions/string_to_string.dart';
import 'package:xplor/utils/widgets/loading_animation.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../utils/common_top_header.dart';
import '../../../multi_lang/domain/mappers/seeker_home/seeker_home_keys.dart';
import '../../../my_orders/presentation/blocs/my_orders_bloc/my_orders_bloc.dart';
import '../../../my_orders/presentation/blocs/my_orders_bloc/my_orders_event.dart';

class StartCoursePage extends StatefulWidget {
  const StartCoursePage({super.key, required this.courseUrl});

  final String courseUrl;

  @override
  State<StartCoursePage> createState() => _StartCoursePageState();
}

class _StartCoursePageState extends State<StartCoursePage> {
  WebViewController? controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    debugPrint(
        "media_url... ${context.read<ApplyCourseBloc>().courseMediaUrl}");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
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
      ..loadRequest(Uri.parse(widget.courseUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PopScope(
      canPop: sl<SharedPreferencesHelper>()
          .getBoolean(PrefConstKeys.isStartUrlMyCourse),
      onPopInvoked: (val) {
        bool data = sl<SharedPreferencesHelper>()
            .getBoolean(PrefConstKeys.isStartUrlMyCourse);

        if (!data) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.seekerHome,
            (routes) => false,
          );
        } else {
          _callOrderApi();
        }
      },
      child: Column(
        children: [_appBarView(), _bodyView()],
      ),
    ));
  }

  _appBarView() {
    return CommonTopHeader(
        title: SeekerHomeKeys.startCourse.stringToString,
        onBackButtonPressed: () {
          bool data = sl<SharedPreferencesHelper>()
              .getBoolean(PrefConstKeys.isStartUrlMyCourse);

          if (data) {
            Navigator.pop(context);
            //_callOrderApi();
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.seekerHome,
              (routes) => false,
            );
          }
        });
  }

  _bodyView() {
    return Expanded(
        child: Stack(
      children: [
        WebViewWidget(controller: controller!),
        if (isLoading) const LoadingAnimation()
      ],
    ));
  }

  void _callOrderApi() {
    context
        .read<MyOrdersBloc>()
        .add(const MyOrdersDataEvent(isFirstTime: true));
    context
        .read<MyOrdersBloc>()
        .add(const MyOrdersCompletedEvent(isFirstTime: true));
  }
}
