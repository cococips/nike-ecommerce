import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/auth/domain/models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  
  Future<Either<Failure, AppUser>> signInWithEmail(String email, String password);
  Future<Either<Failure, AppUser>> signUpWithEmail(String email, String password, String name);
  Future<Either<Failure, AppUser>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
}
