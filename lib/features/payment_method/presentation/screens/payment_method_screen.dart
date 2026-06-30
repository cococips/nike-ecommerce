import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/core/theme/app_colors.dart';
import 'package:nike_ecommerce/features/payment_method/presentation/providers/payment_method_providers.dart';
import 'package:nike_ecommerce/features/payment_method/domain/models/payment_method_model.dart';

class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentMethodListProvider);

    ref.listen<AsyncValue<void>>(
      paymentMethodControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.toString()}')),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: paymentsAsync.when(
        data: (payments) {
          if (payments.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_off_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada metode pembayaran',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan metode pembayaran untuk memudahkan transaksi',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: payments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final payment = payments[index];
              return _buildPaymentCard(context, ref, payment);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              context.push('/payment/add');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Tambah Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, WidgetRef ref, PaymentMethodModel payment) {
    IconData getIcon() {
      if (payment.type.toLowerCase().contains('card')) return Icons.credit_card;
      if (payment.type.toLowerCase().contains('bank')) return Icons.account_balance;
      return Icons.account_balance_wallet;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: payment.isDefault ? AppColors.primary : Colors.grey.shade200,
          width: payment.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(getIcon(), color: Colors.black87),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        payment.type,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (payment.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Utama',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  payment.details,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Hapus Pembayaran'),
                    content: const Text('Yakin ingin menghapus metode pembayaran ini?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  await ref.read(paymentMethodControllerProvider.notifier).deletePaymentMethod(payment.id);
                  ref.invalidate(paymentMethodListProvider);
                }
              } else if (value == 'set_default') {
                await ref.read(paymentMethodControllerProvider.notifier).setDefaultPaymentMethod(payment.id);
                ref.invalidate(paymentMethodListProvider);
              }
            },
            itemBuilder: (BuildContext context) => [
              if (!payment.isDefault)
                const PopupMenuItem(
                  value: 'set_default',
                  child: Text('Jadikan Utama'),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
