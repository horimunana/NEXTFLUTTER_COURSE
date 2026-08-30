import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/filtrers/models/filter_model.dart';
import 'package:summer_shop/features/filtrers/providers/filter_provider.dart';
import 'package:summer_shop/features/filtrers/providers/filtered_products_provider.dart';
import 'package:summer_shop/features/home/providers/cart_provider.dart';
import 'package:summer_shop/features/home/widget/product_grid.dart';
import 'package:summer_shop/utils/theme.dart';

/// Animated cart icon with a bouncing badge (bounces when the count changes).
class CartIconButton extends HookConsumerWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider);

    return IconButton(
      onPressed: () => context.pushNamed('cart'),
      tooltip: 'Cart',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Stack(
          key: ValueKey(count),
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 26),
            if (count > 0)
              Positioned(
                right: -4,
                top: -6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: ThemeColor.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final filter = ref.watch(filterProvider);
    final productsAsync = ref.watch(filteredProductsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: ThemeColor.secondary,
                  child: Icon(Icons.person, color: ThemeColor.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: ThemeColor.grayText,
                          fontSize: 13,
                        ),
                      ),
                      const Text(
                        'Shop with us',
                        style: TextStyle(
                          color: ThemeColor.text,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const CartIconButton(),
                IconButton(
                  onPressed: () => context.pushNamed('login'),
                  tooltip: 'Account',
                  icon: const Icon(Icons.account_circle_outlined, size: 26),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              readOnly: true,
              onTap: () => context.pushNamed('search'),
              decoration: const InputDecoration(
                hintText: 'Search products, categories...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.tune),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Category chips
          SizedBox(
            height: 38,
            child: categoriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (error, _) => const SizedBox.shrink(),
              data: (categories) {
                final all = ['All', ...categories];
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: all.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = all[index];
                    final selected = filter.category == category;
                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) => ref
                          .read(filterProvider.notifier)
                          .setCategory(category),
                      selectedColor: ThemeColor.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : ThemeColor.text,
                        fontWeight: FontWeight.w600,
                      ),
                      showCheckmark: false,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Products header + sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'All Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.text,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _showSortMenu(context, ref),
                  icon: const Icon(Icons.swap_vert, size: 18),
                  label: Text(
                    filter.sort.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Product grid (handles loading / error / empty / data)
          Expanded(child: ProductGrid(productsAsync: productsAsync)),
        ],
      ),
    );
  }

  void _showSortMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final currentSort = ref.read(filterProvider).sort;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sort products',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              for (final option in SortOption.values)
                ListTile(
                  leading: Icon(
                    Icons.check,
                    color: option == currentSort
                        ? ThemeColor.primary
                        : Colors.transparent,
                  ),
                  title: Text(option.label),
                  onTap: () {
                    ref.read(filterProvider.notifier).setSort(option);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}