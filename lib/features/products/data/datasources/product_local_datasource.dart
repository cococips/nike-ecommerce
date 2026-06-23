import 'package:hive/hive.dart';
import 'package:nike_ecommerce/core/utils/logger.dart';
import '../../domain/models/product.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<Product> products);
  Future<List<Product>> getCachedProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String boxName = 'products_cache';

  @override
  Future<void> cacheProducts(List<Product> products) async {
    try {
      final box = await Hive.openBox<Map>(boxName);
      // Clear old cache
      await box.clear();
      // Save new products as JSON map
      final Map<String, Map> mapToSave = {
        for (var p in products) p.id: p.toJson()
      };
      await box.putAll(mapToSave);
      log.d('Cached ${products.length} products locally.');
    } catch (e) {
      log.e('Failed to cache products', error: e);
    }
  }

  @override
  Future<List<Product>> getCachedProducts() async {
    try {
      final box = await Hive.openBox<Map>(boxName);
      if (box.isEmpty) return [];

      return box.values.map((jsonMap) {
        return Product.fromJson(Map<String, dynamic>.from(jsonMap));
      }).toList();
    } catch (e) {
      log.e('Failed to load cached products', error: e);
      return [];
    }
  }
}
