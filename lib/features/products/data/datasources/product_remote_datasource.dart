import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String category);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (doc.exists) {
      return Product.fromFirestore(doc);
    } else {
      throw Exception('Product not found');
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  @override
  Future<void> addProduct(Product product) async {
    // Generate a new ID if it's empty, or use the provided one
    final docRef = product.id.isEmpty
        ? _firestore.collection('products').doc()
        : _firestore.collection('products').doc(product.id);
    
    // We copy the product and inject the auto-generated ID if needed
    final productToSave = product.copyWith(id: docRef.id);
    final data = productToSave.toJson();
    // remove id from the document fields since it is the document ID
    data.remove('id');
    
    await docRef.set(data);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final data = product.toJson();
    data.remove('id');
    await _firestore.collection('products').doc(product.id).update(data);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
}
