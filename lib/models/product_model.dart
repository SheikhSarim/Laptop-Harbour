import 'package:laptops_harbour/models/user_review.dart';

class ProductModel {
  final String id;
  final String name;
  final String brandId;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final List<String> specifications;
  final List<UserReview> reviews;
  final int quantity; 
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.brandId,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.rating = 0.0,
    required this.specifications,
    required this.reviews,
    required this.quantity,
    required this.category,
  });

  bool get inStock => quantity > 0; 

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brandId': brandId,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'specifications': specifications,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'quantity': quantity,
      'category': category,
    };
  }

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      name: map['name'] ?? 'Unnamed Product',
      brandId: map['brandId'] ?? 'unknown',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : 0.0,
      specifications: List<String>.from(map['specifications'] ?? []),
      reviews:
          map['reviews'] != null
              ? List<UserReview>.from(
                (map['reviews'] as List).map((x) => UserReview.fromMap(x)),
              )
              : [],
      quantity: map['quantity'] ?? 0,
      category: map['category'] ?? 'General',
    );
  }
}
