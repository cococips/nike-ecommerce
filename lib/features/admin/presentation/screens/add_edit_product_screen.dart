import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/admin/presentation/providers/admin_product_controller.dart';

class AddEditProductScreen extends ConsumerStatefulWidget {
  final Product? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  ConsumerState<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends ConsumerState<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;
  late TextEditingController _stockController;
  late TextEditingController _imageUrlController; // For manual URL input
  
  List<String> _existingImageUrls = [];
  List<File> _newImageFiles = [];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descController = TextEditingController(text: p?.description ?? '');
    
    final initialPrice = p?.price.toInt() ?? 0;
    _priceController = TextEditingController(
      text: initialPrice > 0 
          ? NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(initialPrice) 
          : '',
    );
    
    final validCategories = ['Running', 'Basketball', 'Football', 'Gym & Training', 'Trail Running'];
    final initialCat = p?.category ?? 'Running';
    _categoryController = TextEditingController(text: validCategories.contains(initialCat) ? initialCat : 'Running');
    _stockController = TextEditingController(text: p?.stock.toString() ?? '10');
    _imageUrlController = TextEditingController();
    
    if (p != null) {
      _existingImageUrls = List.from(p.imageUrls);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newImageFiles.add(File(pickedFile.path));
      });
    }
  }

  void _addManualImageUrl() {
    final url = _imageUrlController.text.trim();
    if (url.isNotEmpty) {
      setState(() {
        _existingImageUrls.add(url);
        _imageUrlController.clear();
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImageFiles.removeAt(index);
    });
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final priceString = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final price = double.tryParse(priceString) ?? 0.0;
    final stock = int.tryParse(_stockController.text) ?? 0;

    final product = Product(
      id: widget.product?.id ?? '', // empty id for new
      name: _nameController.text,
      description: _descController.text,
      price: price,
      category: _categoryController.text,
      stock: stock,
      imageUrls: _existingImageUrls,
      sizes: widget.product?.sizes ?? [40, 41, 42, 43], // Default sizes for now
      colors: widget.product?.colors ?? ['Black', 'White'], // Default colors
      createdAt: widget.product?.createdAt ?? DateTime.now(),
    );

    final controller = ref.read(adminProductControllerProvider.notifier);
    bool success;
    
    if (widget.product == null) {
      success = await controller.addProduct(product, _newImageFiles);
    } else {
      success = await controller.updateProduct(product, _newImageFiles);
    }

    if (success && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProductControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        actions: [
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProduct,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoryController.text,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: ['Running', 'Basketball', 'Football', 'Gym & Training', 'Trail Running']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    _categoryController.text = val;
                  }
                },
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              const Text('Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              
              // Manual URL input
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'Add Image URL (press enter)', border: OutlineInputBorder()),
                      onFieldSubmitted: (_) => _addManualImageUrl(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addManualImageUrl,
                  )
                ],
              ),
              const SizedBox(height: 8),
              
              // Gallery Picker Button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Image from Gallery'),
              ),
              
              const SizedBox(height: 16),
              
              // Image Previews
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Existing URL images
                  ..._existingImageUrls.asMap().entries.map((e) {
                    final index = e.key;
                    final url = e.value;
                    return Stack(
                      children: [
                        Image.network(url, width: 100, height: 100, fit: BoxFit.cover,
                          errorBuilder: (_,__,___) => Container(width: 100, height: 100, color: Colors.grey, child: const Icon(Icons.broken_image)),
                        ),
                        Positioned(
                          right: 0, top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _removeExistingImage(index),
                          ),
                        )
                      ],
                    );
                  }),
                  // New Local Files
                  ..._newImageFiles.asMap().entries.map((e) {
                    final index = e.key;
                    final file = e.value;
                    return Stack(
                      children: [
                        Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                        Positioned(
                          right: 0, top: 0,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => _removeNewImage(index),
                          ),
                        )
                      ],
                    );
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final numericString = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericString.isEmpty) return const TextEditingValue();
    final number = int.parse(numericString);
    final formatted = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0).format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
