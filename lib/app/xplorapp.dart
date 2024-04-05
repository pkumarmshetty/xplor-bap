import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/routes/app_routes.dart';
import '../config/services/app_services.dart';
import '../features/on_boarding/presentation/pages/sign_in/sign_in_view.dart';

class XplorApp extends StatelessWidget {
  const XplorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppServices.navState,
          onGenerateRoute: AppRoutes.onGenerateRoutes,
          home: const SignInView(),
        );
      },
    );
  }
}
