import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/cart/data/repositories/firebase_cart_repository.dart';
import 'package:nike_ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:nike_ecommerce/features/products/data/repositories/firebase_product_repository.dart';
import 'package:nike_ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  return FirebaseProductRepository(ref.watch(firebaseFirestoreProvider));
}

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) {
  return FirebaseCartRepository(ref.watch(firebaseFirestoreProvider));
}
