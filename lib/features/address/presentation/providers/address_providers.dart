import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/features/address/data/repositories/firebase_address_repository.dart';
import 'package:nike_ecommerce/features/address/domain/models/address_model.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'address_providers.g.dart';

@Riverpod(keepAlive: true)
FirebaseAddressRepository addressRepository(Ref ref) {
  return FirebaseAddressRepository(FirebaseFirestore.instance);
}

@riverpod
Future<List<AddressModel>> addressList(Ref ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return [];
  }
  
  final repository = ref.watch(addressRepositoryProvider);
  return await repository.getUserAddresses(user.id);
}

@riverpod
class AddressController extends _$AddressController {
  @override
  FutureOr<void> build() {
    // Initial state
  }

  Future<void> addAddress(AddressModel address) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.addAddress(address);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(addressRepositoryProvider);
      await repository.updateAddress(address);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAddress(String addressId) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final repository = ref.read(addressRepositoryProvider);
        await repository.deleteAddress(user.id, addressId);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    state = const AsyncValue.loading();
    try {
      final user = ref.read(currentUserProvider);
      if (user != null) {
        final repository = ref.read(addressRepositoryProvider);
        await repository.setDefaultAddress(user.id, addressId);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

