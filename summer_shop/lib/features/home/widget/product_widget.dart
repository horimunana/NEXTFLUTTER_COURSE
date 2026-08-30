import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/favorites/provider/favorites_provider.dart';
import 'package:summer_shop/features/home/models/product_model.dart';
import 'package:summer_shop/features/home/providers/cart_provider.dart';
import 'package:summer_shop/utils/theme.dart';

/// A small, animated "+" button used to add a product to the cart.
class AddToCartButton extends StatefulWidget {
  const AddToCartButton({super.key, required this.product, this.size = 34});

  final ProductModel product;
  final double size;

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addToCart(WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    // Play the scale "pop" animation, then update the cart.
    await _controller.forward(from: 0);

    ref.read(cartProvider.notifier).addToCart(widget.product);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${widget.product.title} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, _) {
        return ScaleTransition(
          scale: _scale,
          child: Material(
            color: ThemeColor.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _addToCart(ref),
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Favorite (heart) toggle button.
class FavoriteButton extends HookConsumerWidget {
  const FavoriteButton({super.key, required this.product, this.size = 20});

  final ProductModel product;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((item) => item.id == product.id);

    return IconButton(
      onPressed: () => ref.read(favoritesProvider.notifier).toggle(product),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.redAccent : Colors.black54,
        size: size,
      ),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
    );
  }
}

/// Compact product card used in the catalog grid.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final ProductModel product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(
                  color: Color(0xFFF0F0F4),
                  child: Center(
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const ColoredBox(
                    color: Color(0xFFF0F0F4),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: ThemeColor.grayText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: ThemeColor.text,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ThemeColor.primary,
                          ),
                        ),
                      ),
                      FavoriteButton(product: product, size: 18),
                      AddToCartButton(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}