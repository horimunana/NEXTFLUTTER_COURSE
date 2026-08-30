/// Sort options available in the catalog / search.
enum SortOption {
  none('Default'),
  priceAsc('Price: Low to High'),
  priceDesc('Price: High to Low'),
  titleAsc('Name: A to Z');

  const SortOption(this.label);
  final String label;
}

/// Filter + sort selection used by the search page.
class FilterModel {
  final String query;
  final String category;
  final SortOption sort;

  const FilterModel({
    this.query = '',
    this.category = 'All',
    this.sort = SortOption.none,
  });

  FilterModel copyWith({
    String? query,
    String? category,
    SortOption? sort,
  }) {
    return FilterModel(
      query: query ?? this.query,
      category: category ?? this.category,
      sort: sort ?? this.sort,
    );
  }
}