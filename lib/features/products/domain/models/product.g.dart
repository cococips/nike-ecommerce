// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrls: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  category: json['category'] as String,
  sizes: (json['sizes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  colors: (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
  stock: (json['stock'] as num).toInt(),
  createdAt: _dateTimeFromTimestamp(json['createdAt']),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'imageUrls': instance.imageUrls,
  'category': instance.category,
  'sizes': instance.sizes,
  'colors': instance.colors,
  'stock': instance.stock,
  'createdAt': _dateTimeToTimestamp(instance.createdAt),
};
