import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/products/domain/repositories/product_repository.dart';

class FirebaseProductRepository implements ProductRepository {
  final FirebaseFirestore _firestore;

  FirebaseProductRepository(this._firestore);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        // Fallback for ID if not strictly in document data, use doc.id
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
      return Right(products);
    } on FirebaseException catch (e) {
      return Left(Failure('Firebase Error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return Left(Failure('Product not found'));
      }
      final data = doc.data()!;
      data['id'] = doc.id;
      return Right(Product.fromJson(data));
    } on FirebaseException catch (e) {
      return Left(Failure('Firebase Error: ${e.message}'));
    } catch (e) {
      return Left(Failure('Failed to fetch product: $e'));
    }
  }
}
