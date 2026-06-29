import 'package:nike_ecommerce/features/orders/domain/models/order.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderModel order, String userId);
  Stream<List<OrderModel>> getUserOrders(String userId);
}
