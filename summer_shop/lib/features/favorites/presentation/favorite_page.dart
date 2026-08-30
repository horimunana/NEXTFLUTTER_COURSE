import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/favorites/provider/favorites_provider.dart';
import 'package:summer_shop/features/home/widget/product_widget.dart';
import 'package:summer_shop/utils/theme.dart';

class FavoritePage extends HookConsumerWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                const Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.text,
                  ),
                ),
                const Spacer(),
                Text(
                  '${favorites.length} saved',
                  style: const TextStyle(color: ThemeColor.grayText),
                ),
              ],
            ),
          ),
          Expanded(
            child: favorites.isEmpty
                ? _EmptyFavorites()
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];
                      return ProductCard(
                        product: product,
                        onTap: () => context.pushNamed(
                          'detail',
                          pathParameters: {'id': '${product.id}'},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the heart on any product to save it here.',
            style: TextStyle(color: ThemeColor.grayText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}