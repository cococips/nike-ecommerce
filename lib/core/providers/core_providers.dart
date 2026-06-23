import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nike_ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:nike_ecommerce/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:nike_ecommerce/features/cart/data/repositories/firebase_cart_repository.dart';
import 'package:nike_ecommerce/features/cart/domain/repositories/cart_repository.dart';
import 'package:nike_ecommerce/features/products/data/datasources/product_local_datasource.dart';
import 'package:nike_ecommerce/features/products/data/datasources/product_remote_datasource.dart';
import 'package:nike_ecommerce/features/products/data/repositories/firebase_product_repository.dart';
import 'package:nike_ecommerce/features/products/domain/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) {
  return GoogleSignIn();
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  );
}

@Riverpod(keepAlive: true)
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  return ProductRemoteDataSourceImpl(ref.watch(firebaseFirestoreProvider));
}

@Riverpod(keepAlive: true)
ProductLocalDataSource productLocalDataSource(Ref ref) {
  return ProductLocalDataSourceImpl();
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  return FirebaseProductRepository(
    ref.watch(productRemoteDataSourceProvider),
    ref.watch(productLocalDataSourceProvider),
  );
}

@Riverpod(keepAlive: true)
CartRepository cartRepository(Ref ref) {
  return FirebaseCartRepository(
    ref.watch(firebaseFirestoreProvider),
    ref.watch(authRepositoryProvider),
  );
}
