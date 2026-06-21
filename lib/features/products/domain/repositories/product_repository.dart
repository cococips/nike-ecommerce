import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';

abstract class ProductRepository {
  /// Fetches a list of all products
  Future<Either<Failure, List<Product>>> getProducts();
  
  /// Fetches a specific product by its ID
  Future<Either<Failure, Product>> getProductById(String id);
}
