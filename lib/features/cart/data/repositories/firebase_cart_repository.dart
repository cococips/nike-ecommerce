import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/cart/domain/models/cart_item.dart';
import 'package:nike_ecommerce/features/cart/domain/repositories/cart_repository.dart';

class FirebaseCartRepository implements CartRepository {
  final FirebaseFirestore _firestore;

  FirebaseCartRepository(this._firestore);

  // Assuming a single generic 'cart' collection for this foundation.
  // In a real app, this would be under a specific user's document e.g. users/{userId}/cart/
  CollectionReference get _cartCollection => _firestore.collection('cart');

  @override
  Future<Either<Failure, List<CartItem>>> getCart() async {
    try {
      final snapshot = await _cartCollection.get();
      final cartItems = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Assign document ID to model ID
        return CartItem.fromJson(data);
      }).toList();
      return Right(cartItems);
    } on FirebaseException catch (e) {
      return Left(Failure('Firebase Error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to fetch cart: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      // Use the model's json but don't explicitly store ID in document if we rely on documentId
      final data = item.toJson();
      // Remove ID from data to let Firestore auto-generate, or use item.id if provided
      if (item.id.isEmpty) {
        data.remove('id');
        await _cartCollection.add(data);
      } else {
        await _cartCollection.doc(item.id).set(data);
      }
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure('Firebase Error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to add to cart: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      await _cartCollection.doc(cartItemId).update({'quantity': newQuantity});
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure('Firebase Error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to update quantity: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String cartItemId) async {
    try {
      await _cartCollection.doc(cartItemId).delete();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(Failure('Firebase Error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to remove from cart: $e'));
    }
  }
}
