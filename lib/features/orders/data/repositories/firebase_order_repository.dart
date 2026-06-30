import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_ecommerce/features/orders/domain/models/order.dart';
import 'package:nike_ecommerce/features/orders/domain/repositories/order_repository.dart';

class FirebaseOrderRepository implements OrderRepository {
  final FirebaseFirestore _firestore;

  FirebaseOrderRepository(this._firestore);

  @override
  Future<void> placeOrder(OrderModel order, String userId) async {
    final batch = _firestore.batch();
    
    // 1. Save the order to users/{userId}/orders/{orderId}
    final orderRef = _firestore.collection('users').doc(userId).collection('orders').doc(order.id);
    batch.set(orderRef, order.toJson());
    
    // 2. Clear the cart users/{userId}/cart
    final cartRef = _firestore.collection('users').doc(userId).collection('cart');
    final cartSnapshot = await cartRef.get();
    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Execute atomic batch
    await batch.commit();
  }

  @override
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collectionGroup('orders')
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return OrderModel.fromJson(data);
      }).toList();
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  @override
  Future<void> updateOrderStatus(String userId, String orderId, String status) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }
}
