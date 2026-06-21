import 'package:nike_ecommerce/core/providers/core_providers.dart';
import 'package:nike_ecommerce/features/cart/domain/models/cart_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_providers.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  FutureOr<List<CartItem>> build() async {
    return _fetchCart();
  }

  Future<List<CartItem>> _fetchCart() async {
    final repository = ref.watch(cartRepositoryProvider);
    final result = await repository.getCart();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (cartItems) => cartItems,
    );
  }

  Future<void> addToCart(CartItem item) async {
    final repository = ref.read(cartRepositoryProvider);
    final result = await repository.addToCart(item);
    
    result.fold(
      (failure) {
        // In a real app we might show a snackbar here or update a separate error state
        throw Exception(failure.message);
      },
      (_) {
        // Refresh cart
        state = const AsyncValue.loading();
        state = AsyncValue.data([...state.value ?? [], item]);
        // Ideally we fetch again to get the generated IDs if needed, but for optimism we can just append
        ref.invalidateSelf();
      },
    );
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.updateQuantity(cartItemId, newQuantity);
    ref.invalidateSelf();
  }

  Future<void> removeFromCart(String cartItemId) async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.removeFromCart(cartItemId);
    ref.invalidateSelf();
  }
}
