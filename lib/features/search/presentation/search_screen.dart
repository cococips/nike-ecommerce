import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/products/presentation/widgets/product_card.dart';
import 'package:nike_ecommerce/features/search/presentation/providers/search_providers.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final searchState = ref.watch(searchFilteredProductsProvider);
    final selectedCategory = ref.watch(searchCategoryProvider);

    final categories = ['All', 'Running', 'Basketball', 'Football', 'Gym & Training', 'Trail Running'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header & Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) => ref.read(searchQueryProvider.notifier).setQuery(value),
                    decoration: InputDecoration(
                      hintText: 'Search for shoes...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),

            // Category Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  
                  return GestureDetector(
                    onTap: () {
                      ref.read(searchCategoryProvider.notifier).setCategory(category);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Search Results Grid
            Expanded(
              child: searchState.when(
                data: (products) {
                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'No products found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
