import 'package:flutter/material.dart';
import 'package:xplor/features/home/presentation/pages/home_page.dart';
import 'package:xplor/features/on_boarding/presentation/pages/choose_role/choose_role_view.dart';
import 'package:xplor/features/on_boarding/presentation/pages/complete_kyc/complete_kyc_view.dart';
import 'package:xplor/features/on_boarding/presentation/pages/sign_in/sign_in_view.dart';

import '../../features/on_boarding/presentation/pages/otp/otp_view.dart';
import 'path_routing.dart';

/// Class responsible for handling app routes and generating appropriate route widgets.
class AppRoutes {
  /// Generates and returns the appropriate route based on the provided [RouteSettings].
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.main:
        // Return a material route for the main route, displaying HomeTabs widget.
        return _materialRoute(const SignInView());
      case Routes.login:
        //return _materialRoute(const SignInView());
        return customPageRoute(const SignInView());
      case Routes.otp:
        // Return a material route for the OTP route, displaying OtpView widget.
        return customPageRoute(
          const OtpView(),
        );
      case Routes.kyc:
        return customPageRoute(const CompleteKYCView());
      case Routes.chooseRole:
        return customPageRoute(const ChooseRoleView());
      case Routes.home:
        return customPageRoute(const HomePage());
      default:
        // Return a default material route, displaying SplashView for unknown routes.
        return customPageRoute(const SignInView());
    }
  }

  /// Private method to create a [MaterialPageRoute] with the provided widget.
  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute<dynamic>(builder: (_) => view);
  }

  /// Private method to create a [customPageRoute] with the provided widget & animation.
  static Route<dynamic> customPageRoute(Widget view) {
    return PageRouteBuilder(
      // Builds the page with the specified [view].
      pageBuilder: (_, __, ___) => view,
      // Builds the transition animation.
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          // Animates the position from off-screen right to the center of the screen.
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Start position (off-screen right)
            end: Offset.zero, // End position (center of the screen)
          ).animate(animation),
          child: child, // Displays the child widget during the transition.
        );
      },
    );
  }
}
