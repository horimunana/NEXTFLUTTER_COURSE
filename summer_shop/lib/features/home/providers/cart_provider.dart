import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/core/provider/shared_preferences_provider.dart';
import 'package:summer_shop/features/home/models/cart_model.dart';
import 'package:summer_shop/features/home/models/product_model.dart';

/// State + business logic for the shopping cart.
///
/// The cart is persisted locally with [SharedPreferences] so it survives
/// an app restart.
class CartController extends Notifier<List<CartModel>> {
  static const _storageKey = 'cart_items';

  @override
  List<CartModel> build() {
    return _restore();
  }

  // --- Persistence -------------------------------------------------------

  List<CartModel> _restore() {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = prefs.getString(_storageKey);
    if (raw == null) return [];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((item) => CartModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _persist() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final raw = jsonEncode(
      state.map((item) => item.toJson()).toList(),
    );
    await prefs.setString(_storageKey, raw);
  }

  // --- Cart operations ---------------------------------------------------

  Future<void> addToCart(ProductModel product) async {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      // Product already in the cart -> increase quantity.
      state = [
        for (var i = 0; i < state.length; i++)
          i == index ? state[i].copyWith(quantity: state[i].quantity + 1) : state[i],
      ];
    } else {
      state = [...state, CartModel(product: product, quantity: 1)];
    }
    await _persist();
  }

  Future<void> decreaseQuantity(ProductModel product) async {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index < 0) return;

    final item = state[index];
    if (item.quantity <= 1) {
      // Quantity would drop below 1 -> remove the line.
      state = state.where((e) => e.product.id != product.id).toList();
    } else {
      state = [
        for (var i = 0; i < state.length; i++)
          i == index ? item.copyWith(quantity: item.quantity - 1) : state[i],
      ];
    }
    await _persist();
  }

  Future<void> removeFromCart(ProductModel product) async {
    state = state.where((item) => item.product.id != product.id).toList();
    await _persist();
  }

  Future<void> clearCart() async {
    state = [];
    await _persist();
  }
}

/// Cart controller/provider (state = list of line items).
final cartProvider =
    NotifierProvider<CartController, List<CartModel>>(CartController.new);

/// Total number of items across all lines (used for the badge).
final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (sum, item) => sum + item.quantity,
      );
});

/// Total price of the cart.
final cartTotalProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );
});