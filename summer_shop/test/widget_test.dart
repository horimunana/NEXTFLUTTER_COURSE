import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:summer_shop/core/provider/shared_preferences_provider.dart';
import 'package:summer_shop/features/filtrers/models/filter_model.dart';
import 'package:summer_shop/features/filtrers/providers/filter_provider.dart';
import 'package:summer_shop/features/filtrers/providers/filtered_products_provider.dart';
import 'package:summer_shop/features/favorites/provider/favorites_provider.dart';
import 'package:summer_shop/features/home/models/product_model.dart';
import 'package:summer_shop/features/home/providers/cart_provider.dart';
import 'package:summer_shop/features/home/providers/product_providers.dart';
import 'package:summer_shop/features/home/widget/product_widget.dart';

ProductModel _product(
  int id, {
  String title = 'Classic T-Shirt',
  String category = 'Clothes',
  int price = 10,
}) {
  return ProductModel(
    id: id,
    title: title,
    price: price,
    description: 'A nice product',
    category: category,
    images: const [],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        productApiProvider.overrideWith((ref) async => [
              _product(1, title: 'Red Shirt', price: 15, category: 'Clothes'),
              _product(
                2,
                title: 'Wireless Mouse',
                price: 30,
                category: 'Electronics',
              ),
            ]),
      ],
    );
    addTearDown(container.dispose);
  });

  group('CartController', () {
    test('adds, increments, decrements and removes items', () async {
      final notifier = container.read(cartProvider.notifier);
      final shirt = _product(1, price: 15);

      await notifier.addToCart(shirt);
      expect(container.read(cartProvider).single.quantity, 1);
      expect(container.read(cartTotalProvider), 15);

      await notifier.addToCart(shirt);
      expect(container.read(cartProvider).single.quantity, 2);
      expect(container.read(cartCountProvider), 2);
      expect(container.read(cartTotalProvider), 30);

      await notifier.decreaseQuantity(shirt);
      expect(container.read(cartProvider).single.quantity, 1);

      await notifier.decreaseQuantity(shirt);
      expect(container.read(cartProvider), isEmpty);
    });

    test('persists the cart across provider rebuilds', () async {
      final notifier = container.read(cartProvider.notifier);
      await notifier.addToCart(_product(7, title: 'Sunglasses'));

      final second = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(second.dispose);

      final restored = second.read(cartProvider);
      expect(restored.single.product.id, 7);
      expect(restored.single.product.title, 'Sunglasses');
    });
  });

  group('FavoritesController', () {
    test('toggles favorite state and removes items', () async {
      final notifier = container.read(favoritesProvider.notifier);

      await notifier.toggle(_product(1));
      await notifier.toggle(_product(2));

      expect(container.read(favoritesProvider).length, 2);
      expect(notifier.isFavorite(1), isTrue);

      await notifier.toggle(_product(2));
      expect(container.read(favoritesProvider).single.id, 1);
    });

    test('persists favorites across provider rebuilds', () async {
      await container.read(favoritesProvider.notifier).toggle(_product(3));

      final second = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(second.dispose);

      expect(second.read(favoritesProvider).single.id, 3);
    });
  });

  group('Filtering & sorting', () {
    /// Resolves the product catalog first, then reads the derived list.
    Future<List<ProductModel>> resolve(String query, String category,
        SortOption sort) async {
      await container.read(productApiProvider.future);
      final filter = container.read(filterProvider.notifier);
      filter.setQuery(query);
      filter.setCategory(category);
      filter.setSort(sort);
      return container.read(filteredProductsProvider).value ?? const [];
    }

    test('filters by query', () async {
      final result = await resolve('shirt', 'All', SortOption.none);
      expect(result.single.id, 1);
    });

    test('filters by category', () async {
      final result = await resolve('', 'Electronics', SortOption.none);
      expect(result.single.id, 2);
    });

    test('sorts by price descending', () async {
      final result = await resolve('', 'All', SortOption.priceDesc);
      expect(result.map((p) => p.id), [2, 1]);
    });
  });

  group('Widgets', () {
    testWidgets('AddToCartButton shows a snack bar and bumps the cart',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: AddToCartButton(product: _product(1)),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AddToCartButton));
      // Let the pop animation finish and the SnackBar build over several frames.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 150));
      }

      expect(find.text('Classic T-Shirt added to cart'), findsOneWidget);
    });

    test('kicks off a product fetch returning an AsyncValue', () async {
      final async = container.read(productApiProvider);
      expect(async.isLoading, isTrue);

      final products = await container.read(productApiProvider.future);
      expect(products, hasLength(2));
      expect(products.first.category, 'Clothes');
    });
  });
}