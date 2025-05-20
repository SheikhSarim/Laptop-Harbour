import 'package:laptops_harbour/models/user_review.dart';

class ProductModel {
  final String id;
  final String name;
  final String brandId; // 🔗 Reference to brand (ID only)
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final List<String> specifications;
  final List<UserReview> reviews;
  final bool inStock;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.brandId,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.specifications,
    required this.reviews,
    required this.inStock,
    required this.category,
  });

  // 🔄 Convert to Firestore Map (save only brandId)
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
      'inStock': inStock,
      'category': category,
    };
  }

  // 🔄 Create from Firestore Map
  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id, // Use Firestore doc ID, not the one in map (or missing)
      name: map['name'] ?? 'Unnamed Product',
      brandId: map['brandId'] ?? 'unknown',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      specifications: List<String>.from(map['specifications'] ?? []),
      reviews:
          map['reviews'] != null
              ? List<UserReview>.from(
                (map['reviews'] as List).map((x) => UserReview.fromMap(x)),
              )
              : [],
      inStock: map['inStock'] ?? true,
      category: map['category'] ?? 'General',
    );
  }
}
