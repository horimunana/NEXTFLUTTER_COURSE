import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/home/models/cart_model.dart';
import 'package:summer_shop/features/home/models/product_model.dart';
import 'package:summer_shop/features/home/providers/cart_provider.dart';
import 'package:summer_shop/features/home/providers/product_providers.dart';
import 'package:summer_shop/features/home/widget/product_widget.dart';
import 'package:summer_shop/utils/theme.dart';

class DetailPage extends HookConsumerWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(
          GoRouterState.of(context).pathParameters['id'] ?? '',
        ) ??
        0;

    final productAsync = ref.watch(productDetailProvider(id));

    return Scaffold(
      appBar: AppBar(),
      body: productAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (product) => _DetailBody(product: product),
      ),
    );
  }
}

class _DetailBody extends HookConsumerWidget {
  const _DetailBody({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    final CartModel? lineItem = cart
        .where((item) => item.product.id == product.id)
        .firstOrNull;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        _ImageCarousel(images: product.images),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeColor.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeColor.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FavoriteButton(product: product, size: 26),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${product.price}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.primary,
                ),
              ),
              const Divider(height: 32),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThemeColor.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: ThemeColor.grayText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              // Add to cart / quantity controls
              _AddToCartBar(product: product, quantity: lineItem?.quantity ?? 0),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.images});

  final List<String> images;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isEmpty ? const [''] : widget.images;

    return Column(
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (value) => setState(() => _page = value),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    images[index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(
                      color: Color(0xFFF0F0F4),
                      child: Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (images.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < images.length; i++)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _page
                        ? ThemeColor.primary
                        : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

/// Full-width "Add to cart" bar. Shows a quantity stepper once the product
/// is in the cart and plays a scale animation when an item is added.
class _AddToCartBar extends HookConsumerWidget {
  const _AddToCartBar({required this.product, required this.quantity});

  final ProductModel product;
  final int quantity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 350),
    );
    final scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.06), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1), weight: 50),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return ScaleTransition(
      scale: scale,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (quantity > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QuantityStepper(product: product),
            ),
          FilledButton.icon(
            onPressed: () async {
              controller.forward(from: 0);
              await ref
                  .read(cartProvider.notifier)
                  .addToCart(product);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Added to cart'),
                    duration: Duration(seconds: 1),
                  ),
                );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text(
              'Add to Cart',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quantity minus / plus controls bound to the cart state.
class QuantityStepper extends HookConsumerWidget {
  const QuantityStepper({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref
        .watch(cartProvider)
        .where((item) => item.product.id == product.id)
        .firstOrNull
        ?.quantity ?? 0;

    final notifier = ref.read(cartProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ThemeColor.text,
          ),
        ),
        const SizedBox(width: 12),
        _StepperButton(
          icon: Icons.remove,
          onTap: () => notifier.decreaseQuantity(product),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$quantity',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _StepperButton(
          icon: Icons.add,
          onTap: () => notifier.addToCart(product),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColor.secondary,
        ),
        child: Icon(icon, size: 18, color: ThemeColor.primary),
      ),
    );
  }
}