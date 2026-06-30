import 'package:nike_ecommerce/features/orders/domain/models/order.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderModel order, String userId);
  Stream<List<OrderModel>> getUserOrders(String userId);
  Stream<List<OrderModel>> getAllOrders();
  Future<void> updateOrderStatus(String userId, String orderId, String status);
}
