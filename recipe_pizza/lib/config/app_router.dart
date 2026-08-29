import 'package:go_router/go_router.dart';

import '../features/detail/presentation/detail_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/form/presentation/add_recipe_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/about/presentation/about_screen.dart';

abstract class AppRoutes {
  static const home = '/';
  static const detail = '/recipe/:id';
  static const favorites = '/favorites';
  static const addRecipe = '/add';
  static const about = '/about';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'recipe/:id',
          name: 'detail',
          builder: (context, state) => DetailScreen(
            recipeId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: 'favorites',
          name: 'favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: 'add',
          name: 'add-recipe',
          builder: (context, state) => const AddRecipeScreen(),
        ),
        GoRoute(
          path: 'about',
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
      ],
    ),
  ],
);
