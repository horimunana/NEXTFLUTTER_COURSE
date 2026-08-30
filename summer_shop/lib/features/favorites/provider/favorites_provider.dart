import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/core/provider/shared_preferences_provider.dart';
import 'package:summer_shop/features/home/models/product_model.dart';

/// State + business logic for the favorites/wishlist.
///
/// Favorites are persisted locally with [SharedPreferences] so the list
/// survives an app restart (no API involved).
class FavoritesController extends Notifier<List<ProductModel>> {
  static const _storageKey = 'favorite_items';

  @override
  List<ProductModel> build() {
    return _restore();
  }

  List<ProductModel> _restore() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_storageKey);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = jsonEncode(state.map((product) => product.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  bool isFavorite(int productId) {
    return state.any((product) => product.id == productId);
  }

  Future<void> toggle(ProductModel product) async {
    if (isFavorite(product.id)) {
      state = state.where((item) => item.id != product.id).toList();
    } else {
      state = [...state, product];
    }
    await _persist();
  }

  Future<void> remove(ProductModel product) async {
    state = state.where((item) => item.id != product.id).toList();
    await _persist();
  }
}

/// Favorites controller/provider (state = list of favorite products).
final favoritesProvider =
    NotifierProvider<FavoritesController, List<ProductModel>>(
  FavoritesController.new,
);