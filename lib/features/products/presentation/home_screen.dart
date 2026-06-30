import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/l10n/app_localizations.dart';
import 'package:nike_ecommerce/features/products/presentation/providers/product_providers.dart';
import 'package:nike_ecommerce/features/products/presentation/widgets/product_card.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/core/utils/currency_formatter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['All', 'Running', 'Basketball', 'Football', 'Gym & Training', 'Trail Running'];

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    
    final firstName = user?.displayName?.split(' ').first ?? 'Guest';

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => ref.read(productsProvider.notifier).refresh(),
        color: Colors.black,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              expandedHeight: 60,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    radius: 20,
                    backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
                    child: user?.photoUrl == null 
                        ? const Icon(Icons.person, color: Colors.grey) 
                        : null,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Hello, $firstName 👋',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildCategories(),
            ),
            ...productsState.when(
              data: (products) {
                if (products.isEmpty) {
                  return [
                    SliverFillRemaining(
                      child: Center(child: Text(l10n.noProducts)),
                    )
                  ];
                }
                
                // Filter products based on selected category
                final filteredProducts = _selectedCategoryIndex == 0 
                    ? products 
                    : products.where((p) => p.category.toLowerCase().contains(_categories[_selectedCategoryIndex].toLowerCase())).toList();
                
                final featured = products.take(3).toList();
                
                return [
                  SliverToBoxAdapter(
                    child: _buildFeatured(featured),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Popular Shoes',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {}, 
                            child: const Text('See All', style: TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (filteredProducts.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              const Text(
                                'No products found in this category',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ProductCard(product: filteredProducts[index]);
                          },
                          childCount: filteredProducts.length,
                        ),
                      ),
                    ),
                ];
              },
              loading: () => [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildSkeletonCard();
                      },
                      childCount: 6,
                    ),
                  ),
                ),
              ],
              error: (error, stackTrace) => [
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${l10n.failedToLoad}:\n${error.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                          onPressed: () {
                            ref.read(productsProvider.notifier).refresh();
                          },
                          child: Text(l10n.retry, style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatured(List<Product> featured) {
    if (featured.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Text(
            'New Arrivals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final product = featured[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'BEST SELLER',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.price.toIdr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: product.imageUrls.isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.network(
                                product.imageUrls.first,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            )
                          : const Icon(Icons.image, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF6F6F6),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
