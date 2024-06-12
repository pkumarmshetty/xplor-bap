import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xplor/features/multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import 'package:xplor/utils/app_colors.dart';
import 'package:xplor/utils/app_dimensions.dart';
import 'package:xplor/utils/extensions/font_style/font_styles.dart';
import 'package:xplor/utils/mapping_const.dart';
import 'package:xplor/utils/utils.dart';
import 'package:xplor/utils/widgets/app_background_widget.dart';

import '../../../../config/routes/path_routing.dart';
import '../../../../const/local_storage/shared_preferences_helper.dart';
import '../../../../core/check_route.dart';
import '../../../../core/dependency_injection.dart';
import '../../../../gen/assets.gen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int translationLoadCount = 0;
  int totalTranslationCount = 0;

  @override
  void initState() {
    super.initState();

    sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.appForBelem, false);

    if (sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode) == 'en') {
      if (checkScreenCompletion() == Routes.seekerHome) {
        sl<SharedPreferencesHelper>().setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
      }
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, checkScreenCompletion());
        }
      });
    } else {
      if (checkScreenCompletion() == Routes.seekerHome) {
        sl<SharedPreferencesHelper>().setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
        totalTranslationCount = 2;
        context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
            langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
            moduleTypes: seekerHomeModule,
            isNavigation: true));
        context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
            langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
            moduleTypes: walletModule,
            isNavigation: true));
        sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isDirectFromSplash, true);
      } else if (checkScreenCompletion() == Routes.home) {
        totalTranslationCount = 1;
        context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
            langCode: sl<SharedPreferencesHelper>().getString(PrefConstKeys.selectedLanguageCode),
            moduleTypes: homeModule,
            isNavigation: true));
        sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.isDirectFromSplash, true);
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            if (checkScreenCompletion() != Routes.seekerHome && checkScreenCompletion() != Routes.home) {
              //Navigator.pushReplacementNamed(context, Routes.welcomePage);
              Navigator.pushReplacementNamed(context, checkScreenCompletion());
            }
          }
        });
      }
    }

    /*Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, checkScreenCompletion());
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AppBackgroundDecoration(
            child: BlocListener<TranslationBloc, TranslateState>(
      listener: (context, state) {
        if (state is TranslationLoaded && state.isNavigation) {
          translationLoadCount++;
          if (translationLoadCount == totalTranslationCount) {
            //Navigator.pushNamed(context, Routes.walkThrough);
            var prefs = sl<SharedPreferencesHelper>();
            var role = prefs.getString(PrefConstKeys.selectedRole);
            if (kDebugMode) {
              print("checkRoles..... $role");
            }
            if (role == PrefConstKeys.seekerKey) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.seekerHome,
                (routes) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.home,
                (routes) => false,
              );
            }
          }
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SvgPicture.asset(
            Assets.images.splash,
            height: double.infinity,
            width: double.infinity,
          ).scaleXAnimated(),

          /*SvgPicture.asset(
            Assets.images.poweredByXplor,
            height: 42.w,
            width: 183.w,
          ).paddingAll(padding: AppDimensions.medium).fadeInAnimated()*/
          "Powered by Xplor-Beckn"
              .titleSemiBold(color: AppColors.primaryLightColor, size: 14.sp)
              .paddingAll(padding: AppDimensions.medium)
              .fadeInAnimated()
        ],
      ),
    )));
  }
}
