import 'package:nike_ecommerce/core/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_providers.g.dart';

@riverpod
class WishlistNotifier extends _$WishlistNotifier {
  @override
  FutureOr<List<String>> build() async {
    return _fetchWishlist();
  }

  Future<List<String>> _fetchWishlist() async {
    final repository = ref.watch(wishlistRepositoryProvider);
    final result = await repository.getWishlist();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (productIds) => productIds,
    );
  }

  Future<void> toggleFavorite(String productId) async {
    // Optimistic UI update
    final previousState = state.value;
    if (previousState != null) {
      if (previousState.contains(productId)) {
        state = AsyncValue.data(previousState.where((id) => id != productId).toList());
      } else {
        state = AsyncValue.data([...previousState, productId]);
      }
    }

    final repository = ref.read(wishlistRepositoryProvider);
    final result = await repository.toggleFavorite(productId);

    result.fold(
      (failure) {
        // Rollback on failure
        if (previousState != null) {
          state = AsyncValue.data(previousState);
        }
        throw Exception(failure.message);
      },
      (_) {
        // Invalidate to ensure we're in sync with server, though optimistic is often enough
        ref.invalidateSelf();
      },
    );
  }
}
