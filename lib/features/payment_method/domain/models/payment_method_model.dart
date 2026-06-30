import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  final String id;
  final String userId;
  final String type; // e.g. Credit Card, Bank Transfer, E-Wallet
  final String details; // e.g. **** **** **** 1234
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.details,
    this.isDefault = false,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? details,
    bool? isDefault,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      details: details ?? this.details,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'details': details,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map, String documentId) {
    return PaymentMethodModel(
      id: documentId,
      userId: map['userId'] ?? '',
      type: map['type'] ?? '',
      details: map['details'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  factory PaymentMethodModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return PaymentMethodModel.fromMap(data, doc.id);
  }
}
