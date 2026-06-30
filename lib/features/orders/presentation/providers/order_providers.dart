import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nike_ecommerce/core/providers/core_providers.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:nike_ecommerce/features/cart/presentation/providers/cart_providers.dart';
import 'package:nike_ecommerce/features/cart/presentation/providers/cart_total_provider.dart';
import 'package:nike_ecommerce/features/orders/domain/models/order.dart';
import 'package:uuid/uuid.dart';

part 'order_providers.g.dart';

@riverpod
Stream<List<OrderModel>> userOrders(Ref ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getUserOrders(user.id);
}

@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  bool build() => false; // returns loading state

  Future<void> placeOrder({
    required String recipientName,
    required String address,
    required String paymentMethod,
  }) async {
    state = true;
    try {
      final user = ref.read(authStateChangesProvider).value;
      if (user == null) throw Exception('User not logged in');

      final cartItems = ref.read(cartProvider).value ?? [];
      if (cartItems.isEmpty) throw Exception('Cart is empty');

      final totalAmount = ref.read(cartTotalProvider);
      final orderRepository = ref.read(orderRepositoryProvider);

      final order = OrderModel(
        id: const Uuid().v4(),
        userId: user.id,
        items: cartItems,
        totalAmount: totalAmount,
        recipientName: recipientName,
        address: address,
        status: 'Dikemas',
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
      );

      await orderRepository.placeOrder(order, user.id);
      
      // Riverpod state for cart is auto-refreshed via stream from Firestore (since batch deletes the cart docs)
    } finally {
      state = false;
    }
  }
}

@riverpod
Stream<List<OrderModel>> allOrders(Ref ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);
  return orderRepository.getAllOrders();
}

@riverpod
class AdminOrderController extends _$AdminOrderController {
  @override
  bool build() => false;

  Future<void> updateOrderStatus(String userId, String orderId, String status) async {
    state = true;
    try {
      final repository = ref.read(orderRepositoryProvider);
      await repository.updateOrderStatus(userId, orderId, status);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    } finally {
      state = false;
    }
  }
}
