import 'package:flutter/material.dart';

import '../../../core/models/recipe.dart';
import '../../../core/stores/recipe_store.dart';
import '../../../responsive/responsive_builder.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/stats_chip.dart';

class DetailScreen extends StatelessWidget {
  final String recipeId;

  const DetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final store = RecipeStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final recipe = store.byId(recipeId);
        if (recipe == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Recipe not found')),
          );
        }
        final isFav = store.isFavorite(recipe.id);
        return Scaffold(
          appBar: AppBar(
            title: Text(recipe.name),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                onPressed: () => store.toggleFavorite(recipe.id),
              ),
            ],
          ),
          body: ResponsiveBuilder(
            builder: (context, breakpoint) {
              final wide = breakpoint.isTablet || breakpoint.isDesktop;
              final content = _RecipeContent(recipe: recipe);
              if (wide) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _HeroImage(recipe: recipe)),
                      const SizedBox(width: 24),
                      Expanded(child: content),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroImage(recipe: recipe),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: content,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _HeroImage extends StatelessWidget {
  final Recipe recipe;

  const _HeroImage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Image.network(
              recipe.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return Container(
                  height: 280,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.restaurant, size: 64)),
                );
              },
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                recipe.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeContent extends StatelessWidget {
  final Recipe recipe;

  const _RecipeContent({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatsChip(icon: Icons.schedule, label: '${recipe.totalTime} min'),
            StatsChip(icon: Icons.people, label: '${recipe.servings} servings'),
            StatsChip(
                icon: Icons.local_fire_department,
                label: '${recipe.difficulty}/3 difficulty'),
          ],
        ),
        const SectionHeader(title: 'Ingredients', icon: Icons.shopping_basket),
        ...recipe.ingredients.map(
          (ing) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(Icons.check_circle,
                    size: 18, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(ing),
              ],
            ),
          ),
        ),
        const SectionHeader(title: 'Steps', icon: Icons.format_list_numbered),
        ...List.generate(recipe.steps.length, (index) {
          final step = recipe.steps[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text('${index + 1}', style: const TextStyle(fontSize: 13)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(step)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
