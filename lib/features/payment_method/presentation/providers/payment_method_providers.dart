import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/payment_method/data/repositories/firebase_payment_repository.dart';
import 'package:nike_ecommerce/features/payment_method/domain/models/payment_method_model.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_method_providers.g.dart';

@Riverpod(keepAlive: true)
FirebasePaymentRepository paymentRepository(Ref ref) {
  return FirebasePaymentRepository(FirebaseFirestore.instance);
}

@riverpod
Future<List<PaymentMethodModel>> paymentMethodList(Ref ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return [];
  }
  
  final repository = ref.watch(paymentRepositoryProvider);
  return await repository.getUserPaymentMethods(user.id);
}

@riverpod
class PaymentMethodController extends _$PaymentMethodController {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<void> addPaymentMethod(PaymentMethodModel payment) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(paymentRepositoryProvider);
      await repository.addPaymentMethod(payment);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePaymentMethod(PaymentMethodModel payment) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(paymentRepositoryProvider);
      await repository.updatePaymentMethod(payment);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePaymentMethod(String paymentId) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final repository = ref.read(paymentRepositoryProvider);
        await repository.deletePaymentMethod(user.id, paymentId);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setDefaultPaymentMethod(String paymentId) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final repository = ref.read(paymentRepositoryProvider);
        await repository.setDefaultPaymentMethod(user.id, paymentId);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

