// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  selectedSize: (json['selectedSize'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'product': instance.product.toJson(),
  'selectedSize': instance.selectedSize,
  'quantity': instance.quantity,
};
