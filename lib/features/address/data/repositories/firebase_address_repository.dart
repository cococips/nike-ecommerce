import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_ecommerce/features/address/domain/models/address_model.dart';

class FirebaseAddressRepository {
  final FirebaseFirestore _firestore;

  FirebaseAddressRepository(this._firestore);

  CollectionReference _addressRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('addresses');
  }

  Future<List<AddressModel>> getUserAddresses(String userId) async {
    try {
      final snapshot = await _addressRef(userId).get();
      return snapshot.docs
          .map((doc) => AddressModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      final ref = _addressRef(address.userId).doc();
      
      // If it's the first address, or marked as default, make it default
      // and unset others if needed.
      if (address.isDefault) {
        await _unsetOtherDefaults(address.userId);
      }

      final newAddress = address.copyWith(id: ref.id);
      await ref.set(newAddress.toMap());
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    try {
      if (address.isDefault) {
        await _unsetOtherDefaults(address.userId);
      }
      
      await _addressRef(address.userId)
          .doc(address.id)
          .update(address.toMap());
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      await _addressRef(userId).doc(addressId).delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      await _unsetOtherDefaults(userId);
      await _addressRef(userId).doc(addressId).update({'isDefault': true});
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }

  Future<void> _unsetOtherDefaults(String userId) async {
    final snapshot = await _addressRef(userId).where('isDefault', isEqualTo: true).get();
    
    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isDefault': false});
    }
    
    await batch.commit();
  }
}
