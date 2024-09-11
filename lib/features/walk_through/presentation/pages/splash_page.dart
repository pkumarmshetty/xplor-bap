import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../multi_lang/presentation/blocs/bloc/translate_bloc.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/extensions/font_style/font_styles.dart';
import '../../../../utils/mapping_const.dart';
import '../../../../utils/utils.dart';
import '../../../../utils/widgets/app_background_widget.dart';
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

  String route = checkScreenCompletion();

  @override
  void initState() {
    super.initState();

    sl<SharedPreferencesHelper>().setBoolean(PrefConstKeys.appForBelem, false);

    if (sl<SharedPreferencesHelper>()
            .getString(PrefConstKeys.selectedLanguageCode) ==
        'en') {
      if (route == Routes.seekerHome) {
        sl<SharedPreferencesHelper>()
            .setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
      }
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, route);
        }
      });
    } else {
      if (route == Routes.seekerHome) {
        sl<SharedPreferencesHelper>()
            .setString(PrefConstKeys.loginFrom, PrefConstKeys.seekerHomeKey);
        totalTranslationCount = 2;
        context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
            langCode: sl<SharedPreferencesHelper>()
                .getString(PrefConstKeys.selectedLanguageCode),
            moduleTypes: seekerHomeModule,
            isNavigation: true));
        context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
            langCode: sl<SharedPreferencesHelper>()
                .getString(PrefConstKeys.selectedLanguageCode),
            moduleTypes: walletModule,
            isNavigation: true));
        sl<SharedPreferencesHelper>()
            .setBoolean(PrefConstKeys.isDirectFromSplash, true);
      } else if (route == Routes.home) {
        totalTranslationCount = 1;
        context.read<TranslationBloc>().add(TranslateDynamicTextEvent(
            langCode: sl<SharedPreferencesHelper>()
                .getString(PrefConstKeys.selectedLanguageCode),
            moduleTypes: homeModule,
            isNavigation: true));
        sl<SharedPreferencesHelper>()
            .setBoolean(PrefConstKeys.isDirectFromSplash, true);
      } else {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            if (route != Routes.seekerHome && route != Routes.home) {
              //Navigator.pushReplacementNamed(context, Routes.welcomePage);
              Navigator.pushReplacementNamed(context, route);
            }
          }
        });
      }
    }
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
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted) {
                goToNext();
              }
            });
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
          "Powered by Beckn-Xplor"
              .titleSemiBold(color: AppColors.primaryLightColor, size: 14.sp)
              .paddingAll(padding: AppDimensions.medium)
              .fadeInAnimated()
        ],
      ),
    )));
  }

  void goToNext() {
    Navigator.pushReplacementNamed(context, route);
  }
}
