import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:laptops_harbour/models/brand_model.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class BrandDetailsScreen extends StatelessWidget {
  final BrandModel brand;

  const BrandDetailsScreen({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    return Scaffold(
      backgroundColor: AppConstants.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text(brand.name),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 180,
            width: double.infinity,
            color: Colors.white,
            child: brand.logoUrl != null
                ? Image.network(brand.logoUrl!, fit: BoxFit.contain)
                : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
          ),

          const SizedBox(height: 12),

          /// 🛒 Related Products Section
          Expanded(
            child: Obx(() {
              // Filter products by brand ID
              final relatedProducts = productController.products
                  .where((product) => product.brandId == brand.id)
                  .toList();

              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (relatedProducts.isEmpty) {
                return const Center(child: Text("No products found for this brand."));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      const Text(
                        "Related Products",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Divider(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// 🛒 Product Cards
                  ...relatedProducts.map((product) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildProductCard(product),
                      )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppConstants.cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("\$${product.price.toStringAsFixed(2)}"),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (i) {
                if (product.rating >= i + 1) {
                  return const Icon(Icons.star, color: Colors.orange, size: 16);
                } else if (product.rating > i) {
                  return const Icon(Icons.star_half, color: Colors.orange, size: 16);
                } else {
                  return const Icon(Icons.star_border, color: Colors.orange, size: 16);
                }
              }),
            ),
          ],
        ),
        onTap: () {
          Get.toNamed('/productDetails/${product.id}');
        },
      ),
    );
  }
}
