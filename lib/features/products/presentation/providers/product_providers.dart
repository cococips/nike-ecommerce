import 'dart:async';
import 'package:nike_ecommerce/core/providers/core_providers.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_providers.g.dart';

@riverpod
class ProductsNotifier extends _$ProductsNotifier {
  @override
  FutureOr<List<Product>> build() async {
    return _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final repository = ref.watch(productRepositoryProvider);
    final result = await repository.getProducts();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProducts());
  }
}

@riverpod
Future<List<Product>> productsByCategory(Ref ref, String category) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProductsByCategory(category);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
}

@riverpod
Future<Product> productById(Ref ref, String id) async {
  final repository = ref.watch(productRepositoryProvider);
  final result = await repository.getProductById(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
}
