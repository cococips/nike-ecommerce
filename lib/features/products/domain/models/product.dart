import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._();
  
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required List<String> imageUrls,
    required String category,
    required List<int> sizes,
    required List<String> colors,
    required int stock,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  // Helper factory untuk konversi dari Firestore DocumentSnapshot
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product.fromJson({
      ...data,
      'id': doc.id,
    });
  }
}

DateTime _dateTimeFromTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    return timestamp.toDate();
  } else if (timestamp is String) {
    return DateTime.parse(timestamp);
  }
  return DateTime.now();
}

Timestamp _dateTimeToTimestamp(DateTime date) => Timestamp.fromDate(date);
