import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/features/cart/presentation/providers/cart_total_provider.dart';
import 'package:nike_ecommerce/features/orders/presentation/providers/order_providers.dart';
import 'package:nike_ecommerce/core/utils/currency_formatter.dart';
import 'package:nike_ecommerce/features/address/presentation/providers/address_providers.dart';
import 'package:nike_ecommerce/features/payment_method/presentation/providers/payment_method_providers.dart';
import 'package:nike_ecommerce/features/address/domain/models/address_model.dart';
import 'package:nike_ecommerce/features/payment_method/domain/models/payment_method_model.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  AddressModel? _selectedAddress;
  PaymentMethodModel? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
  }

  void _placeOrder() async {
    if (_selectedAddress == null || _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an address and payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final formattedAddress = '${_selectedAddress!.street}, ${_selectedAddress!.city}, ${_selectedAddress!.state} ${_selectedAddress!.zipCode}';
      final formattedPayment = '${_selectedPaymentMethod!.type} - ${_selectedPaymentMethod!.details}';

      await ref.read(checkoutControllerProvider.notifier).placeOrder(
        recipientName: _selectedAddress!.recipientName,
        address: formattedAddress,
        paymentMethod: formattedPayment,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/orders'); // Redirect to orders screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _selectAddress(List<AddressModel> addresses) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: addresses.length,
          itemBuilder: (context, index) {
            final addr = addresses[index];
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(addr.recipientName),
              subtitle: Text('${addr.street}, ${addr.city}'),
              trailing: addr.isDefault ? const Chip(label: Text('Default')) : null,
              onTap: () {
                setState(() => _selectedAddress = addr);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _selectPaymentMethod(List<PaymentMethodModel> methods) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: methods.length,
          itemBuilder: (context, index) {
            final method = methods[index];
            return ListTile(
              leading: const Icon(Icons.credit_card),
              title: Text(method.type),
              subtitle: Text(method.details),
              trailing: method.isDefault ? const Chip(label: Text('Default')) : null,
              onTap: () {
                setState(() => _selectedPaymentMethod = method);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(checkoutControllerProvider);
    final totalAmount = ref.watch(cartTotalProvider);

    final addressListAsync = ref.watch(addressListProvider);
    final paymentListAsync = ref.watch(paymentMethodListProvider);

    if (addressListAsync is AsyncData && _selectedAddress == null) {
      final addresses = addressListAsync.value ?? [];
      if (addresses.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedAddress = addresses.firstWhere((a) => a.isDefault, orElse: () => addresses.first);
            });
          }
        });
      }
    }

    if (paymentListAsync is AsyncData && _selectedPaymentMethod == null) {
      final methods = paymentListAsync.value ?? [];
      if (methods.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedPaymentMethod = methods.firstWhere((m) => m.isDefault, orElse: () => methods.first);
            });
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    final addresses = addressListAsync.value ?? [];
                    if (addresses.isEmpty) {
                      context.push('/address');
                    } else {
                      _selectAddress(addresses);
                    }
                  },
                  child: Text(addressListAsync.value?.isEmpty == true ? 'Add' : 'Change'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedAddress == null
                  ? const Text('No address selected', style: TextStyle(color: Colors.grey))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_selectedAddress!.recipientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${_selectedAddress!.street}, ${_selectedAddress!.city}'),
                        Text('${_selectedAddress!.state} ${_selectedAddress!.zipCode}'),
                        const SizedBox(height: 4),
                        Text(_selectedAddress!.phoneNumber),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    final methods = paymentListAsync.value ?? [];
                    if (methods.isEmpty) {
                      context.push('/payment');
                    } else {
                      _selectPaymentMethod(methods);
                    }
                  },
                  child: Text(paymentListAsync.value?.isEmpty == true ? 'Add' : 'Change'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedPaymentMethod == null
                  ? const Text('No payment method selected', style: TextStyle(color: Colors.grey))
                  : Row(
                      children: [
                        const Icon(Icons.credit_card, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_selectedPaymentMethod!.type, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(_selectedPaymentMethod!.details),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    totalAmount.toIdr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (isLoading || _selectedAddress == null || _selectedPaymentMethod == null)
                    ? null
                    : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
