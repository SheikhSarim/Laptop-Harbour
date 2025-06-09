// ignore_for_file: file_names

import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/models/user_model.dart';
import 'package:laptops_harbour/models/user_review.dart';
import 'package:laptops_harbour/utils/add_review_function.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

void showAddReviewDialog(
  BuildContext context,
  ProductModel product,
  UserModel currentUser,
) {
  final ratingController = TextEditingController();
  final reviewController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppConstants.surfaceColor,
        title: const Text('Add Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ratingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rating (0.0 - 5.0)',
              ),
            ),
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(labelText: 'Review'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final rating = double.tryParse(ratingController.text);
              final reviewText = reviewController.text;

              if (rating == null || rating < 0.0 || rating > 5.0) {
                Get.snackbar('Invalid Rating', 'Please enter a rating between 0.0 and 5.0');
                return;
              }

              if (reviewText.isEmpty) {
                Get.snackbar('Empty Review', 'Please enter a review');
                return;
              }


              final review = UserReview(
                userId: currentUser.userId,
                username: currentUser.username,
                rating: rating,
                reviewText: reviewText,
                date: DateTime.now(),
              );

              await addReviewToProduct(product.id, review);
              Get.back();

              Get.snackbar('Success', 'Review added successfully!');
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
