import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/filtrers/models/filter_model.dart';

/// Controller holding the current search/filter/sort selection.
class FilterController extends Notifier<FilterModel> {
  @override
  FilterModel build() => const FilterModel();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setCategory(String category) =>
      state = state.copyWith(category: category);

  void setSort(SortOption sort) => state = state.copyWith(sort: sort);

  void reset() => state = const FilterModel();
}

/// Filter/sort state provider.
final filterProvider =
    NotifierProvider<FilterController, FilterModel>(FilterController.new);