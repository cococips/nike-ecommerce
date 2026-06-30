import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/products/presentation/home_screen.dart';
import 'package:nike_ecommerce/features/shop/presentation/shop_screen.dart';
import 'package:nike_ecommerce/features/search/presentation/search_screen.dart';
import 'package:nike_ecommerce/features/cart/presentation/bag_screen.dart';
import 'package:nike_ecommerce/features/profile/presentation/profile_screen.dart';
import 'package:nike_ecommerce/features/main/presentation/providers/main_providers.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabIndexProvider);

    final List<Widget> screens = [
      const HomeScreen(),
      const ShopScreen(),
      const SearchScreen(),
      const BagScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true, // Allows background content to flow under the floating nav bar
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 28, right: 28, bottom: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.75), // Glassmorphism white
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(Icons.home_outlined, Icons.home, 0, currentIndex, ref),
                      _buildNavItem(Icons.storefront_outlined, Icons.storefront, 1, currentIndex, ref),
                      _buildNavItem(Icons.search_outlined, Icons.search, 2, currentIndex, ref),
                      _buildNavItem(Icons.shopping_bag_outlined, Icons.shopping_bag, 3, currentIndex, ref),
                      _buildNavItem(Icons.person_outline, Icons.person, 4, currentIndex, ref),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index, int currentIndex, WidgetRef ref) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        ref.read(mainTabIndexProvider.notifier).setIndex(index);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(10), // Smaller padding for a tighter fit
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent, // Black circle for active state
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? Colors.white : Colors.black54, // White icon if active, grey if inactive
          size: 24, // Smaller icon size
        ),
      ),
    );
  }
}
