import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/stores/recipe_store.dart';
import '../../../responsive/responsive_builder.dart';
import '../../../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RecipeStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final favorites = store.favorites;
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64),
                  SizedBox(height: 12),
                  Text('No favorites yet'),
                ],
              ),
            );
          }
          return ResponsiveBuilder(
            builder: (context, breakpoint) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridColumnsFor(breakpoint),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final recipe = favorites[index];
                  return RecipeCard(
                    recipe: recipe,
                    highlight: true,
                    onTap: () => context.pushNamed(
                      'detail',
                      pathParameters: {'id': recipe.id},
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
