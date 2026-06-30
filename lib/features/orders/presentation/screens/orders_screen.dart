import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/orders/presentation/providers/order_providers.dart';
import 'package:nike_ecommerce/core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'dikemas':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case 'dikirim':
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case 'selesai':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order #${order.id.substring(0, 8).toUpperCase()}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('MMM dd, yyyy').format(order.createdAt),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                          _buildStatusBadge(order.status),
                        ],
                      ),
                      const Divider(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.items.length,
                        itemBuilder: (context, itemIndex) {
                          final item = order.items[itemIndex];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.product.imageUrls.first,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image, size: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.product.name,
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Size: ${item.selectedSize} | Qty: ${item.quantity}',
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  (item.product.price * item.quantity).toIdr(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Shipping Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(order.recipientName, style: const TextStyle(fontSize: 12)),
                            Text(order.address, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 12),
                            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(order.paymentMethod, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            order.totalAmount.toIdr(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
