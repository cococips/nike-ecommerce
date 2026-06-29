import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<String>>> getWishlist();
  Future<Either<Failure, void>> toggleFavorite(String productId);
}
