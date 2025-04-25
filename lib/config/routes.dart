import 'package:frontend/ui/screens/home/home.dart';
import 'package:frontend/ui/screens/loader.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/ui/screens/chat.dart';
import 'package:frontend/ui/screens/entities.dart';

class AppRoutes {
  static const String home = '/';
  static const String chat = '/chat';
  static const String loader = '/loader';
}

GoRouter router = GoRouter(
  initialLocation: AppRoutes.loader,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.loader,
      builder: (context, state) => const LoaderScreen(),
    ),
  ],
);