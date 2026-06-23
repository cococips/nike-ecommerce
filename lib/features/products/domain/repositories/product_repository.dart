import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';

abstract class ProductRepository {
  /// Fetches a list of all products
  Future<Either<Failure, List<Product>>> getProducts();
  
  /// Fetches a specific product by its ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Fetches products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);

  /// Adds a new product
  Future<Either<Failure, void>> addProduct(Product product);

  /// Updates an existing product
  Future<Either<Failure, void>> updateProduct(Product product);

  /// Deletes a product by its ID
  Future<Either<Failure, void>> deleteProduct(String id);
}
