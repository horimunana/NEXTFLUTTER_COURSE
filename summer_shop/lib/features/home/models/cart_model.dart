import 'package:summer_shop/features/home/models/product_model.dart';

/// A single line item inside the shopping cart.
class CartModel {
  final ProductModel product;
  final int quantity;

  const CartModel({required this.product, required this.quantity});

  CartModel copyWith({ProductModel? product, int? quantity}) {
    return CartModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  int get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}