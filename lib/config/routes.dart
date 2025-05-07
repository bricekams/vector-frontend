import 'package:frontend/models/entity.dart';
import 'package:frontend/ui/screens/home/home.dart';
import 'package:frontend/ui/screens/loader.dart';
import 'package:frontend/ui/screens/small_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/ui/screens/chat/chat.dart';

class AppRoutes {
  static const String home = '/';
  static const String chat = '/chat';
  static const String loader = '/loader';
  static const String smallScreenError = '/smallScreenError';
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
    GoRoute(
      path: AppRoutes.chat,
      name: AppRoutes.chat,
      builder: (context, state) {
        Entity entity = state.extra as Entity;
        return ChatScreen(entity: entity);
      },
    ),
    GoRoute(
      path: AppRoutes.smallScreenError,
      builder: (context, state) => const ToSmallScreenErrorScreen(),
    ),
  ],
);
