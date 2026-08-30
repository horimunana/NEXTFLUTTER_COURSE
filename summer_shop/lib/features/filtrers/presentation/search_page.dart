import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/filtrers/models/filter_model.dart';
import 'package:summer_shop/features/filtrers/providers/filter_provider.dart';
import 'package:summer_shop/features/filtrers/providers/filtered_products_provider.dart';
import 'package:summer_shop/features/home/widget/product_grid.dart';
import 'package:summer_shop/utils/theme.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController();
    final filter = ref.watch(filterProvider);
    final productsAsync = ref.watch(filteredProductsProvider);

    // Keep the TextField in sync with the shared filter state.
    useEffect(() {
      if (textController.text != filter.query) {
        textController.text = filter.query;
        textController.selection = TextSelection.collapsed(
          offset: textController.text.length,
        );
      }
      return null;
    }, [filter.query]);

    final resultCount = productsAsync.value?.length ?? 0;
    final hasActiveFilter =
        filter.query.isNotEmpty || filter.category != 'All';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          if (hasActiveFilter)
            TextButton(
              onPressed: () => ref.read(filterProvider.notifier).reset(),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: textController,
                  autofocus: true,
                  onChanged: (value) =>
                      ref.read(filterProvider.notifier).setQuery(value),
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _CategoryDropdown(filter: filter),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: _SortDropdown(filter: filter)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$resultCount result${resultCount == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 13,
                  color: ThemeColor.grayText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: ProductGrid(
              productsAsync: productsAsync,
              emptyMessage: 'No products match your search',
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends HookConsumerWidget {
  const _CategoryDropdown({required this.filter});

  final FilterModel filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final categories = categoriesAsync.value ?? [];

    return DropdownButtonFormField<String>(
      initialValue: filter.category,
      isExpanded: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        const DropdownMenuItem(value: 'All', child: Text('All categories')),
        for (final category in categories)
          DropdownMenuItem(value: category, child: Text(category)),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(filterProvider.notifier).setCategory(value);
        }
      },
    );
  }
}

class _SortDropdown extends HookConsumerWidget {
  const _SortDropdown({required this.filter});

  final FilterModel filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownButtonFormField<SortOption>(
      initialValue: filter.sort,
      isExpanded: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: [
        for (final option in SortOption.values)
          DropdownMenuItem(value: option, child: Text(option.label)),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(filterProvider.notifier).setSort(value);
        }
      },
    );
  }
}