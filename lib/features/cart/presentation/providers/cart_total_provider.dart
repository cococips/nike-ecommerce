import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nike_ecommerce/features/cart/presentation/providers/cart_providers.dart';

part 'cart_total_provider.g.dart';

@riverpod
double cartTotal(CartTotalRef ref) {
  final cartItemsAsync = ref.watch(cartProvider);

  return cartItemsAsync.maybeWhen(
    data: (items) {
      double total = 0;
      for (final item in items) {
        total += item.product.price * item.quantity;
      }
      return total;
    },
    orElse: () => 0.0,
  );
}
