import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptops_harbour/models/user_review.dart';

Future<void> addReviewToProduct(String productId, UserReview newReview) async {
  final productRef = FirebaseFirestore.instance.collection('products').doc(productId);
  final productSnapshot = await productRef.get();

  if (!productSnapshot.exists) return;

  final productData = productSnapshot.data()!;
  final reviews = List<Map<String, dynamic>>.from(productData['reviews'] ?? []);
  reviews.add(newReview.toJson());

  // Calculate new average rating
  double totalRating = reviews.fold(0.0, (sum, r) => sum + (r['rating'] ?? 0).toDouble());
  double averageRating = reviews.isNotEmpty ? totalRating / reviews.length : 0.0;

  await productRef.update({
    'reviews': reviews,
    'rating': averageRating,
  });
}

