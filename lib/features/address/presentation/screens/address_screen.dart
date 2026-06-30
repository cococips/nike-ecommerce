import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/core/theme/app_colors.dart';
import 'package:nike_ecommerce/features/address/presentation/providers/address_providers.dart';
import 'package:nike_ecommerce/features/address/domain/models/address_model.dart';

class AddressScreen extends ConsumerWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesAsync = ref.watch(addressListProvider);

    // Listen for error in controller
    ref.listen<AsyncValue<void>>(
      addressControllerProvider,
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
          'Alamat Pengiriman',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada alamat',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan alamat pengiriman untuk mulai berbelanja',
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _buildAddressCard(context, ref, address);
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
              context.push('/address/add');
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
              'Tambah Alamat Baru',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, WidgetRef ref, AddressModel address) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : Colors.grey.shade200,
          width: address.isDefault ? 2 : 1,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      address.recipientName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (address.isDefault) ...[
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
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onSelected: (value) async {
                  if (value == 'edit') {
                    context.push('/address/edit', extra: address);
                  } else if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Alamat'),
                        content: const Text('Yakin ingin menghapus alamat ini?'),
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
                      await ref.read(addressControllerProvider.notifier).deleteAddress(address.id);
                      ref.invalidate(addressListProvider);
                    }
                  } else if (value == 'set_default') {
                    await ref.read(addressControllerProvider.notifier).setDefaultAddress(address.id);
                    ref.invalidate(addressListProvider);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  if (!address.isDefault)
                    const PopupMenuItem(
                      value: 'set_default',
                      child: Text('Jadikan Utama'),
                    ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Ubah Alamat'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.phoneNumber,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Text(
            '${address.street}, ${address.city}, ${address.state} ${address.zipCode}',
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
        ],
      ),
    );
  }
}
