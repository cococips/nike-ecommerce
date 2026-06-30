import 'package:nike_ecommerce/core/providers/core_providers.dart';
import 'package:nike_ecommerce/features/auth/domain/models/app_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
Stream<AppUser?> authStateChanges(Ref ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}

@Riverpod(keepAlive: true)
AppUser? currentUser(Ref ref) {
  ref.watch(authStateChangesProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
}

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithEmail(email, password);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> signUpWithEmail(String email, String password, String name) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signUpWithEmail(email, password, name);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    final result = await repository.signInWithGoogle();
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (user) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);
    await repository.signOut();
    state = const AsyncValue.data(null);
  }
}
