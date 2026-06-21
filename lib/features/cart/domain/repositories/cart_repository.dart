import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/cart/domain/models/cart_item.dart';

abstract class CartRepository {
  /// Fetches the current user's cart items
  Future<Either<Failure, List<CartItem>>> getCart();
  
  /// Adds an item to the cart
  Future<Either<Failure, void>> addToCart(CartItem item);
  
  /// Updates the quantity of a specific cart item
  Future<Either<Failure, void>> updateQuantity(String cartItemId, int newQuantity);
  
  /// Removes an item from the cart
  Future<Either<Failure, void>> removeFromCart(String cartItemId);
}
