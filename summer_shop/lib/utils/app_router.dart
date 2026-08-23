import 'package:go_router/go_router.dart';
import 'package:summer_shop/features/auth/presentation/login_page.dart';
import 'package:summer_shop/features/auth/presentation/register_page.dart';
import 'package:summer_shop/features/favorites/presentation/favorite_page.dart';
import 'package:summer_shop/features/filtrers/presentation/search_page.dart';
import 'package:summer_shop/features/home/presentation/cart_page.dart';
import 'package:summer_shop/features/home/presentation/detail_page.dart';
import 'package:summer_shop/features/home/presentation/home_page.dart';
import 'package:summer_shop/features/profile/presentation/profile_page.dart';

final GoRouter routes = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: "register",
      path: "/register",
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      name: "home",
      path: "/",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: "detail",
      path: "/detail/:id",
      builder: (context, state) => const DetailPage(),
    ),
    GoRoute(
      name: "profile",
      path: "/profile",
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      name: "cart",
      path: "/cart",
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(
      name: "favorite",
      path: "/favorite",
      builder: (context, state) => const FavoritePage(),
    ),
    GoRoute(
      name: "search",
      path: "/search",
      builder: (context, state) => const SearchPage(),
    ),
  ],
);
