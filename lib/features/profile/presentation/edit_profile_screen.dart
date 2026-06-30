import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nike_ecommerce/core/services/storage_service.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:nike_ecommerce/core/providers/core_providers.dart';
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _photoController;
  bool _isLoading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _photoController = TextEditingController(text: user?.photoUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _photoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(currentUserProvider);
      String photoUrl = _photoController.text;

      if (_imageFile != null && user != null) {
        final storageService = ref.read(storageServiceProvider);
        final result = await storageService.uploadImage(
          _imageFile!,
          'profile_images/${user.id}',
        );

        if (result.isRight()) {
          photoUrl = result.getOrElse((_) => photoUrl);
        } else {
          result.fold((failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
            );
          }, (_) {});
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      final repository = ref.read(authRepositoryProvider);
      final result = await repository.updateProfile(
        name: _nameController.text,
        photoUrl: photoUrl,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failure.message), backgroundColor: Colors.red),
            );
          },
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
            );
            context.pop();
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (_photoController.text.isNotEmpty
                              ? NetworkImage(_photoController.text)
                              : null),
                      child: _imageFile == null && _photoController.text.isEmpty
                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              const Text(
                'Note: Leave Photo URL empty if you do not want to change it.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
