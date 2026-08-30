import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/home/models/product_model.dart';
import 'package:summer_shop/features/home/repositories/product_repository.dart';

import '../../../core/api/dio_provider.dart';

/// Exposes the repository that talks to the fake e-commerce API.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(dio: ref.watch(dioProvider));
});

/// Fetches the full product catalog (FutureProvider => AsyncValue).
final productApiProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

/// Fetches a single product for the detail screen.
final productDetailProvider =
    FutureProvider.family<ProductModel, int>((ref, id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProduct(id);
});