import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/core/theme/app_colors.dart';
import 'package:nike_ecommerce/features/address/presentation/providers/address_providers.dart';
import 'package:nike_ecommerce/features/address/domain/models/address_model.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';

class AddEditAddressScreen extends ConsumerStatefulWidget {
  final AddressModel? address;
  
  const AddEditAddressScreen({super.key, this.address});

  @override
  ConsumerState<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.address?.recipientName ?? '');
    _phoneController = TextEditingController(text: widget.address?.phoneNumber ?? '');
    _streetController = TextEditingController(text: widget.address?.street ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _zipController = TextEditingController(text: widget.address?.zipCode ?? '');
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final controller = ref.read(addressControllerProvider.notifier);
    
    final newAddress = AddressModel(
      id: widget.address?.id ?? '',
      userId: user.id,
      recipientName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      zipCode: _zipController.text.trim(),
      isDefault: _isDefault,
    );

    if (widget.address == null) {
      await controller.addAddress(newAddress);
    } else {
      await controller.updateAddress(newAddress);
    }
    
    // Invalidate provider to refresh list
    ref.invalidate(addressListProvider);

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addressControllerProvider).isLoading;
    final isEditing = widget.address != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Ubah Alamat' : 'Tambah Alamat',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
              const Text('Kontak', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _nameController,
                label: 'Nama Lengkap Penerima',
                validator: (v) => v!.isEmpty ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Nomor Telepon',
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Nomor telepon harus diisi' : null,
              ),
              const SizedBox(height: 24),
              const Text('Alamat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _stateController,
                label: 'Provinsi',
                validator: (v) => v!.isEmpty ? 'Provinsi harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _cityController,
                label: 'Kota / Kabupaten',
                validator: (v) => v!.isEmpty ? 'Kota harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _streetController,
                label: 'Nama Jalan, Gedung, No. Rumah',
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'Alamat lengkap harus diisi' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _zipController,
                label: 'Kode Pos',
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Kode pos harus diisi' : null,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Jadikan Alamat Utama', style: TextStyle(fontWeight: FontWeight.w500)),
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
                  onPressed: isLoading ? null : _saveAddress,
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
                          'Simpan Alamat',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }
}
