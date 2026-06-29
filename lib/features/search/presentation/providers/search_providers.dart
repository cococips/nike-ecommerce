import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/products/presentation/providers/product_providers.dart';

part 'search_providers.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class SearchCategory extends _$SearchCategory {
  @override
  String? build() => 'All';

  void setCategory(String? category) => state = category;
}

@riverpod
Future<List<Product>> searchFilteredProducts(SearchFilteredProductsRef ref) async {
  final products = await ref.watch(productsProvider.future);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final category = ref.watch(searchCategoryProvider);

  return products.where((product) {
    final matchesQuery = product.name.toLowerCase().contains(query);
    final matchesCategory = category == null || category == 'All' || product.category.toLowerCase() == category.toLowerCase();
    return matchesQuery && matchesCategory;
  }).toList();
}
