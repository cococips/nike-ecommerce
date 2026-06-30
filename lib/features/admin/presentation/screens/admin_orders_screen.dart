import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/orders/presentation/providers/order_providers.dart';
import 'package:nike_ecommerce/core/utils/currency_formatter.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

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

  void _showUpdateStatusDialog(BuildContext context, WidgetRef ref, String userId, String orderId, String currentStatus) {
    String selectedStatus = currentStatus;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Update Order Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ['Dikemas', 'Dikirim', 'Selesai'].map((status) {
                  return RadioListTile<String>(
                    title: Text(status),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (val) {
                      if (val != null) setState(() => selectedStatus = val);
                    },
                  );
                }).toList(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await ref.read(adminOrderControllerProvider.notifier).updateOrderStatus(userId, orderId, selectedStatus);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status updated')));
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
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
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'No orders found',
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
                                DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt),
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => _showUpdateStatusDialog(context, ref, order.userId, order.id, order.status),
                            child: _buildStatusBadge(order.status),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
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
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 40,
                                      height: 40,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image, size: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                      Text('Qty: ${item.quantity}', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(order.totalAmount.toIdr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Address: ${order.recipientName}, ${order.address}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      Text('Payment: ${order.paymentMethod}', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _showUpdateStatusDialog(context, ref, order.userId, order.id, order.status),
                          child: const Text('Update Status'),
                        ),
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
