import 'package:go_router/go_router.dart';
import 'package:xplor/features/home/presentation/pages/home_page.dart';

class GoRouterSingleton {
  // Private constructor
  GoRouterSingleton._privateConstructor();

  // Static variable to hold the instance
  static final GoRouterSingleton _instance =
      GoRouterSingleton._privateConstructor();

  // Static method to get the instance
  static GoRouterSingleton get instance => _instance;

  // The GoRouter instance
  late final GoRouter _goRouter;

  // Method to initialize the GoRouter instance with your routes
  void initialize() {
    _goRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        // Add more routes as needed
      ],
    );
  }

  // Getter for the GoRouter instance
  GoRouter get goRouter => _goRouter;
}
