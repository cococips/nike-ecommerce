import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:nike_ecommerce/features/auth/domain/models/app_user.dart';
import 'package:nike_ecommerce/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthRepository(this._auth, this._googleSignIn);

  AppUser? _mapFirebaseUser(User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    final isAdmin = email.toLowerCase() == 'admin@gmail.com';
    return AppUser(
      id: user.uid,
      email: email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      isAdmin: isAdmin,
    );
  }

  @override
  Stream<AppUser?> get authStateChanges => _auth.userChanges().map(_mapFirebaseUser);

  @override
  AppUser? get currentUser => _mapFirebaseUser(_auth.currentUser);

  @override
  Future<Either<Failure, AppUser>> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user != null) return right(user);
      return left(const Failure('User not found after sign in.'));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Authentication failed'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUpWithEmail(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      
      final updatedUser = _auth.currentUser;
      final user = _mapFirebaseUser(updatedUser);
      
      if (user != null) return right(user);
      return left(const Failure('User not created successfully.'));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Registration failed'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signInWithGoogle() async {
    try {
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return left(const Failure('Google sign in cancelled by user.'));
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = _mapFirebaseUser(userCredential.user);
      
      if (user != null) return right(user);
      return left(const Failure('Google sign in failed.'));
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Google sign in failed'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile({String? name, String? photoUrl}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return left(const Failure('User not authenticated'));
      }

      if (name != null) {
        await user.updateDisplayName(name);
      }
      if (photoUrl != null && photoUrl.isNotEmpty) {
        await user.updatePhotoURL(photoUrl);
      }

      // Force refresh current user
      await user.reload();
      
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Failed to update profile'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
