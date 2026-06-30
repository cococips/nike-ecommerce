import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/core/theme/app_colors.dart';
import 'package:nike_ecommerce/features/payment_method/presentation/providers/payment_method_providers.dart';
import 'package:nike_ecommerce/features/payment_method/domain/models/payment_method_model.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';

class AddPaymentMethodScreen extends ConsumerStatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  ConsumerState<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends ConsumerState<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedType = 'Kartu Kredit / Debit';
  late TextEditingController _detailsController;
  bool _isDefault = false;

  final List<String> _paymentTypes = [
    'Kartu Kredit / Debit',
    'Transfer Bank',
    'E-Wallet (GoPay, OVO, Dana)',
  ];

  @override
  void initState() {
    super.initState();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _savePaymentMethod() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final controller = ref.read(paymentMethodControllerProvider.notifier);
    
    // Mask details for security (mock implementation)
    String maskedDetails = _detailsController.text.trim();
    if (_selectedType == 'Kartu Kredit / Debit' && maskedDetails.length >= 4) {
      maskedDetails = '**** **** **** ${maskedDetails.substring(maskedDetails.length - 4)}';
    }

    final newPayment = PaymentMethodModel(
      id: '',
      userId: user.id,
      type: _selectedType,
      details: maskedDetails,
      isDefault: _isDefault,
    );

    await controller.addPaymentMethod(newPayment);
    ref.invalidate(paymentMethodListProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(paymentMethodControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Tambah Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tipe Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                items: _paymentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text('Detail Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detailsController,
                keyboardType: _selectedType == 'Transfer Bank' ? TextInputType.text : TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Detail harus diisi' : null,
                decoration: InputDecoration(
                  labelText: _selectedType == 'Kartu Kredit / Debit' 
                      ? 'Nomor Kartu (16 digit)' 
                      : _selectedType == 'Transfer Bank' 
                          ? 'Nama Bank & No. Rekening' 
                          : 'Nomor HP E-Wallet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Jadikan Utama', style: TextStyle(fontWeight: FontWeight.w500)),
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primary,
                value: _isDefault,
                onChanged: (bool value) {
                  setState(() {
                    _isDefault = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _savePaymentMethod,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Simpan Metode Pembayaran',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
