import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/core/utils/logger.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInAnonymously();
  User? get currentUser;
  Stream<User?> get authStateChanges;
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<Either<Failure, User>> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      final user = userCredential.user;
      if (user != null) {
        log.d('Signed in anonymously: ${user.uid}');
        return right(user);
      } else {
        return left(ServerFailure('Failed to sign in anonymously. User is null.'));
      }
    } on FirebaseAuthException catch (e) {
      log.e('Firebase Auth Error', error: e);
      return left(ServerFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      log.e('Auth Error', error: e);
      return left(ServerFailure(e.toString()));
    }
  }
}
