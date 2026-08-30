import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/filtrers/models/filter_model.dart';
import 'package:summer_shop/features/filtrers/providers/filter_provider.dart';
import 'package:summer_shop/features/home/models/product_model.dart';
import 'package:summer_shop/features/home/providers/product_providers.dart';

/// All available product categories (derived from the catalog).
final categoriesProvider = Provider<AsyncValue<List<String>>>((ref) {
  return ref.watch(productApiProvider).whenData(
        (products) => products
            .map((p) => p.category)
            .toSet()
            .toList()
          ..sort(),
      );
});

/// Catalog filtered + sorted according to the current [FilterModel].
///
/// Keeps the loading/error semantics of the underlying `AsyncValue`
/// thanks to [AsyncValue.whenData].
final filteredProductsProvider = Provider<AsyncValue<List<ProductModel>>>((ref) {
  final productsAsync = ref.watch(productApiProvider);
  final filter = ref.watch(filterProvider);

  return productsAsync.whenData(
    (products) {
      final query = filter.query.trim().toLowerCase();

      final filtered = products.where((product) {
        final matchesQuery = query.isEmpty ||
            product.title.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query);
        final matchesCategory =
            filter.category == 'All' || product.category == filter.category;
        return matchesQuery && matchesCategory;
      }).toList();

      switch (filter.sort) {
        case SortOption.none:
          break;
        case SortOption.priceAsc:
          filtered.sort((a, b) => a.price.compareTo(b.price));
        case SortOption.priceDesc:
          filtered.sort((a, b) => b.price.compareTo(a.price));
        case SortOption.titleAsc:
          filtered.sort((a, b) => a.title.compareTo(b.title));
      }

      return filtered;
    },
  );
});