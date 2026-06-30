import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/wishlist/presentation/providers/wishlist_providers.dart';
import 'package:nike_ecommerce/core/utils/currency_formatter.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider).value ?? [];
    final isFavorite = wishlist.contains(product.id);

    return GestureDetector(
      onTap: () => context.push('/product-detail', extra: product),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Background Card
          Padding(
            padding: const EdgeInsets.only(top: 30), // Create space at the top so image can "pop out"
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.5,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.price.toIdr(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // 2. The Pop-out Image
          Positioned(
            top: 0,
            left: 12,
            right: 12,
            bottom: 95, // Reserve space for the text at the bottom
            child: Hero(
              tag: 'product-${product.id}',
              child: Transform.rotate(
                angle: -0.05, // Slight tilt for 3D dynamic effect
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: product.imageUrls.isNotEmpty
                        ? Image.network(
                            product.imageUrls.first,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, color: Colors.grey, size: 48),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, color: Colors.grey, size: 48),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Floating Favorite Button
          Positioned(
            top: 40,
            right: 8,
            child: GestureDetector(
              onTap: () {
                ref.read(wishlistProvider.notifier).toggleFavorite(product.id);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.redAccent : Colors.black87,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
