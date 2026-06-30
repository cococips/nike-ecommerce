import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nike_ecommerce/features/cart/domain/models/cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class OrderModel with _$OrderModel {
  const OrderModel._();
  
  @JsonSerializable(explicitToJson: true)
  const factory OrderModel({
    required String id,
    required String userId,
    required List<CartItem> items,
    required double totalAmount,
    required String recipientName,
    required String address,
    @Default('Dikemas') String status,
    @Default('') String paymentMethod,
    @TimestampConverter() required DateTime createdAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) {
    return Timestamp.fromDate(date);
  }
}
