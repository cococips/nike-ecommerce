import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/wishlist/domain/repositories/wishlist_repository.dart';

class FirebaseWishlistRepository implements WishlistRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseWishlistRepository(this._firestore, this._auth);

  @override
  Future<Either<Failure, List<String>>> getWishlist() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(Failure('User not authenticated'));
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .get();

      final productIds = snapshot.docs.map((doc) => doc.id).toList();
      return Right(productIds);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(Failure('User not authenticated'));
      }

      final docRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('wishlist')
          .doc(productId);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Remove if exists
        await docRef.delete();
      } else {
        // Add if doesn't exist
        await docRef.set({
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
