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
  category: json['category'] as String,
  sizes: (json['sizes'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  imageUrl: json['imageUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  stock: (json['stock'] as num).toInt(),
  isFeatured: json['isFeatured'] as bool,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'category': instance.category,
  'sizes': instance.sizes,
  'imageUrl': instance.imageUrl,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'stock': instance.stock,
  'isFeatured': instance.isFeatured,
};
