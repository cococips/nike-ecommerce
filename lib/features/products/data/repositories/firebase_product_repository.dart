import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/products/domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';
import 'package:nike_ecommerce/core/utils/logger.dart';

class FirebaseProductRepository implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  FirebaseProductRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // Offline-first strategy
      final localProducts = await _localDataSource.getCachedProducts();
      
      if (localProducts.isNotEmpty) {
        log.d('Returning ${localProducts.length} products from local cache.');
        // Optional: Fetch from remote in background to refresh cache
        _refreshCacheInBackground();
        return right(localProducts);
      }

      log.d('Fetching products from remote.');
      final remoteProducts = await _remoteDataSource.getProducts();
      await _localDataSource.cacheProducts(remoteProducts);
      return right(remoteProducts);
    } catch (e) {
      log.e('Error fetching products', error: e);
      return left(ServerFailure(e.toString()));
    }
  }
  
  Future<void> _refreshCacheInBackground() async {
    try {
      final remoteProducts = await _remoteDataSource.getProducts();
      await _localDataSource.cacheProducts(remoteProducts);
      log.d('Background cache refresh successful.');
    } catch (e) {
      log.w('Background cache refresh failed.', error: e);
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      // Check local cache first
      final localProducts = await _localDataSource.getCachedProducts();
      try {
        final product = localProducts.firstWhere((p) => p.id == id);
        return right(product);
      } catch (_) {
        // Not found locally
      }

      final remoteProduct = await _remoteDataSource.getProductById(id);
      return right(remoteProduct);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    try {
      final localProducts = await _localDataSource.getCachedProducts();
      if (localProducts.isNotEmpty) {
        final filtered = localProducts.where((p) => p.category == category).toList();
        if (filtered.isNotEmpty) {
          return right(filtered);
        }
      }

      final remoteProducts = await _remoteDataSource.getProductsByCategory(category);
      return right(remoteProducts);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(Product product) async {
    try {
      await _remoteDataSource.addProduct(product);
      // Refresh cache so UI updates
      _refreshCacheInBackground();
      return right(null);
    } catch (e) {
      log.e('Error adding product', error: e);
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      await _remoteDataSource.updateProduct(product);
      // Refresh cache so UI updates
      _refreshCacheInBackground();
      return right(null);
    } catch (e) {
      log.e('Error updating product', error: e);
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _remoteDataSource.deleteProduct(id);
      // Refresh cache so UI updates
      _refreshCacheInBackground();
      return right(null);
    } catch (e) {
      log.e('Error deleting product', error: e);
      return left(ServerFailure(e.toString()));
    }
  }
}
