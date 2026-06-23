import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/features/products/presentation/providers/product_providers.dart';
import 'package:nike_ecommerce/features/admin/presentation/providers/admin_product_controller.dart';

class AdminProductsScreen extends ConsumerWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsProvider);

    // Listen for error states from the controller
    ref.listen<AsyncValue<void>>(
      adminProductControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: Manage Products'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/admin/add-edit');
        },
        child: const Icon(Icons.add),
      ),
      body: productsState.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('Belum ada produk. Tambahkan sekarang!'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(productsProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: product.imageUrls.isNotEmpty
                      ? Image.network(
                          product.imageUrls.first,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price} - Stock: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          context.push('/admin/add-edit', extra: product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(context, ref, product.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String productId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      ref.read(adminProductControllerProvider.notifier).deleteProduct(productId);
    }
  }
}
