import 'package:frontend/ui/screens/home/home.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/ui/screens/chat.dart';
import 'package:frontend/ui/screens/entities.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/chat';
  static const String entities = '/entities';
}

GoRouter router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.entities,
      builder: (context, state) => const EntitiesScreen(),
    ),
  ],
);