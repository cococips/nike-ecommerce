import 'dart:io';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/core/services/storage_service.dart';
import 'package:nike_ecommerce/core/providers/core_providers.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/products/presentation/providers/product_providers.dart';

final adminProductControllerProvider =
    AsyncNotifierProvider<AdminProductController, void>(() {
  return AdminProductController();
});

class AdminProductController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // Initial state is void (null data)
  }

  Future<bool> addProduct(Product product, List<File> imageFiles) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(productRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      List<String> imageUrls = List.from(product.imageUrls);

      // Upload new images
      for (final file in imageFiles) {
        final result = await storageService.uploadImage(file, 'products');
        result.fold(
          (failure) => throw Exception(failure.message),
          (url) => imageUrls.add(url),
        );
      }

      final newProduct = product.copyWith(imageUrls: imageUrls);
      final result = await repository.addProduct(newProduct);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
          return false;
        },
        (_) {
          state = const AsyncValue.data(null);
          ref.read(productsProvider.notifier).refresh();
          return true;
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }

  Future<bool> updateProduct(Product product, List<File> newImageFiles) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(productRepositoryProvider);
      final storageService = ref.read(storageServiceProvider);

      List<String> imageUrls = List.from(product.imageUrls);

      // Upload new images
      for (final file in newImageFiles) {
        final result = await storageService.uploadImage(file, 'products');
        result.fold(
          (failure) => throw Exception(failure.message),
          (url) => imageUrls.add(url),
        );
      }

      final updatedProduct = product.copyWith(imageUrls: imageUrls);
      final result = await repository.updateProduct(updatedProduct);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
          return false;
        },
        (_) {
          state = const AsyncValue.data(null);
          ref.read(productsProvider.notifier).refresh();
          return true;
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(productRepositoryProvider);
      final result = await repository.deleteProduct(id);

      return result.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
          return false;
        },
        (_) {
          state = const AsyncValue.data(null);
          ref.read(productsProvider.notifier).refresh();
          return true;
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }
}
