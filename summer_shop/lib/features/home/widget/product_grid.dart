import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/home/models/product_model.dart';
import 'package:summer_shop/features/home/providers/product_providers.dart';
import 'package:summer_shop/features/home/widget/product_widget.dart';
import 'package:summer_shop/utils/theme.dart';

/// A reusable catalog grid that renders the three `AsyncValue` states
/// (loading / error / data) for any list of products.
class ProductGrid extends HookConsumerWidget {
  const ProductGrid({
    super.key,
    required this.productsAsync,
    this.emptyMessage = 'No products found',
  });

  final AsyncValue<List<ProductModel>> productsAsync;
  final String emptyMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return productsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: ThemeColor.primary),
      ),
      error: (error, stackTrace) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 52, color: Colors.grey),
                const SizedBox(height: 12),
                const Text(
                  'Failed to load products',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ThemeColor.grayText),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(productApiProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      data: (products) {
        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_outlined,
                    size: 52, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  emptyMessage,
                  style: const TextStyle(color: ThemeColor.grayText),
                ),
              ],
            ),
          );
        }

        final grid = GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.pushNamed('detail', pathParameters: {
                'id': '${product.id}',
              }),
            );
          },
        );

        return grid;
      },
    );
  }
}