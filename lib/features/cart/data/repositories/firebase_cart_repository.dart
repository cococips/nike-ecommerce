import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/cart/domain/models/cart_item.dart';
import 'package:nike_ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:nike_ecommerce/features/auth/domain/repositories/auth_repository.dart';

class FirebaseCartRepository implements CartRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  FirebaseCartRepository(this._firestore, this._authRepository);

  String get _userId {
    final user = _authRepository.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }
    return user.id;
  }


  @override
  Future<Either<Failure, List<CartItem>>> getCart() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .get();
          
      final items = snapshot.docs
          .map((doc) => CartItem.fromFirestore(doc))
          .toList();
      return right(items);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'A database error occurred'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(item.id)
          .set(item.toJson());
      return right(null);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'A database error occurred'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': newQuantity});
      return right(null);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'A database error occurred'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String cartItemId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();
      return right(null);
    } on FirebaseException catch (e) {
      return left(ServerFailure(e.message ?? 'A database error occurred'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
