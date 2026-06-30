import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/main/presentation/providers/main_providers.dart';
import 'package:nike_ecommerce/features/search/presentation/providers/search_providers.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      {
        'title': 'Running',
        'image': 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?q=80&w=800',
      },
      {
        'title': 'Basketball',
        'image': 'https://images.unsplash.com/photo-1519861531473-9200262188bf?q=80&w=800',
      },
      {
        'title': 'Football',
        'image': 'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?q=80&w=800',
      },
      {
        'title': 'Gym & Training',
        'image': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800',
      },
      {
        'title': 'Trail Running',
        'image': 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?q=80&w=800',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Shop by Category',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final title = cat['title']!;
                  final imageUrl = cat['image']!;

                  return GestureDetector(
                    onTap: () {
                      // 1. Set the search filter to this category
                      ref.read(searchCategoryProvider.notifier).setCategory(title);
                      // 2. Navigate to the Search Tab (index 2)
                      ref.read(mainTabIndexProvider.notifier).setIndex(2);
                    },
                    child: Container(
                      height: 140,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade200,
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.35),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
