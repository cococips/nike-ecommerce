import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_ecommerce/features/payment_method/domain/models/payment_method_model.dart';

class FirebasePaymentRepository {
  final FirebaseFirestore _firestore;

  FirebasePaymentRepository(this._firestore);

  CollectionReference _paymentRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('payment_methods');
  }

  Future<List<PaymentMethodModel>> getUserPaymentMethods(String userId) async {
    try {
      final snapshot = await _paymentRef(userId).get();
      return snapshot.docs
          .map((doc) => PaymentMethodModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }

  Future<void> addPaymentMethod(PaymentMethodModel payment) async {
    try {
      final ref = _paymentRef(payment.userId).doc();
      
      if (payment.isDefault) {
        await _unsetOtherDefaults(payment.userId);
      }

      final newPayment = payment.copyWith(id: ref.id);
      await ref.set(newPayment.toMap());
    } catch (e) {
      throw Exception('Failed to add payment method: $e');
    }
  }

  Future<void> updatePaymentMethod(PaymentMethodModel payment) async {
    try {
      if (payment.isDefault) {
        await _unsetOtherDefaults(payment.userId);
      }
      
      await _paymentRef(payment.userId)
          .doc(payment.id)
          .update(payment.toMap());
    } catch (e) {
      throw Exception('Failed to update payment method: $e');
    }
  }

  Future<void> deletePaymentMethod(String userId, String paymentId) async {
    try {
      await _paymentRef(userId).doc(paymentId).delete();
    } catch (e) {
      throw Exception('Failed to delete payment method: $e');
    }
  }

  Future<void> setDefaultPaymentMethod(String userId, String paymentId) async {
    try {
      await _unsetOtherDefaults(userId);
      await _paymentRef(userId).doc(paymentId).update({'isDefault': true});
    } catch (e) {
      throw Exception('Failed to set default payment method: $e');
    }
  }

  Future<void> _unsetOtherDefaults(String userId) async {
    final snapshot = await _paymentRef(userId).where('isDefault', isEqualTo: true).get();
    
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }
    
    await batch.commit();
  }
}
