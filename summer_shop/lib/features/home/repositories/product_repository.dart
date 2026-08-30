import 'package:dio/dio.dart';
import 'package:summer_shop/features/home/models/product_model.dart';

/// Data access layer for the product catalog.
///
/// Uses the free, fake e-commerce API:
///   https://api.escuelajs.co
/// (Platzi Fake Store API). See `lib/features/home/note.txt` for the
/// endpoint details.
class ProductRepository {
  final Dio dio;

  const ProductRepository({required this.dio});

  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get<List<dynamic>>('/api/v1/products');
    final data = response.data ?? [];
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProduct(int id) async {
    final response =
        await dio.get<Map<String, dynamic>>('/api/v1/products/$id');
    return ProductModel.fromJson(response.data ?? {});
  }
}