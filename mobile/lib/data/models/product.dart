// lib/data/models/product.dart
class Product {
  final String id;
  final String title;
  final double price;
  final String? image;
  final String? description;
  final String? source;
  final double? rating;
  final int? reviewCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    this.image,
    this.description,
    this.source,
    this.rating,
    this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
    title: json['title'] ?? 'Unknown',
    price: (json['price'] ?? 999).toDouble(),
    image: json['image'],
    description: json['description'],
    source: json['source'],
    rating: (json['rating'] ?? 4.0).toDouble(),
    reviewCount: json['reviewCount'] ?? 100,
  );
}