import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xplor/core/constants.dart';
import 'package:xplor/core/routes.dart';
import 'package:xplor/features/dynamic_json_ui/presentation/pages/dynamic_form_widget.dart';
import 'package:xplor/features/home/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();

  static Routes routes = Routes();

  static RouterConfig<Object> router() {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: routes.main,
          builder: (BuildContext context, GoRouterState state) {
            return const HomePage();
          },
          routes: <RouteBase>[
            //<<<<===============Add More Pages Below====================>>>>
            GoRoute(
              path: _routerPath(routes.dynamic),
              builder: (BuildContext context, GoRouterState state) {
                return DynamicFormWidget(
                    jsonString:
                        Constants.jsonString); // Add new pages route here
              },
            ),
          ],
        ),
      ],
    );
  }
}

String _routerPath(String s) {
  return s.replaceFirst("/", "");
}
