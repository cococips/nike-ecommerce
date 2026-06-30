import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final String userId;
  final String recipientName;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  AddressModel copyWith({
    String? id,
    String? userId,
    String? recipientName,
    String? phoneNumber,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recipientName: recipientName ?? this.recipientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AddressModel(
      id: documentId,
      userId: map['userId'] ?? '',
      recipientName: map['recipientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AddressModel.fromMap(data, doc.id);
  }
}
