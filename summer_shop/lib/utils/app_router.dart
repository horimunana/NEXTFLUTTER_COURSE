import 'package:go_router/go_router.dart';
import 'package:summer_shop/features/auth/presentation/login_page.dart';
import 'package:summer_shop/features/auth/presentation/register_page.dart';
import 'package:summer_shop/features/favorites/presentation/favorite_page.dart';
import 'package:summer_shop/features/filtrers/presentation/search_page.dart';
import 'package:summer_shop/features/home/presentation/cart_page.dart';
import 'package:summer_shop/features/home/presentation/detail_page.dart';
import 'package:summer_shop/features/home/presentation/home_page.dart';
import 'package:summer_shop/features/profile/presentation/profile_page.dart';
import 'package:summer_shop/utils/main_shell.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: 'detail',
      path: '/detail/:id',
      builder: (context, state) => const DetailPage(),
    ),
    GoRoute(
      name: 'cart',
      path: '/cart',
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      name: 'search',
      path: '/search',
      builder: (context, state) => const SearchPage(),
    ),
    // Bottom-navigation shell with the three main tabs.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'home',
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'favorites',
              path: '/favorites',
              builder: (context, state) => const FavoritePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: 'profile',
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);