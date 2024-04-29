import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/routes/app_routes.dart';
import '../config/routes/path_routing.dart';
import '../config/services/app_services.dart';
import '../config/theme/theme_cubit.dart';
import '../config/theme/theme_data.dart';
import '../const/bloc_providers.dart';

class XplorApp extends StatelessWidget {
  const XplorApp({super.key, this.isLoggedIn = false});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) {
          return MultiBlocProvider(
              //------------------------------------------------------------------------------
              providers: AppBlocProviders.appBlocs,
              //------------------------------------------------------------------------------
              child: BlocBuilder<ThemeCubit, AppTheme>(builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  navigatorKey: AppServices.navState,
                  title: 'Xplor',
                  //theme: state.themeData,
                  onGenerateRoute: AppRoutes.onGenerateRoutes,
                  initialRoute: isLoggedIn ? Routes.home : Routes.main, // Navigate to home or login based on token
                );
              }));
        });
  }
}
