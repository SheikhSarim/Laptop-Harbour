import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/product_controller.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:laptops_harbour/widgets/product_card.dart';

class StoreScreen extends StatelessWidget {
  StoreScreen({super.key});

  final ProductController productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primaryIconColor),
          onPressed: () {
            Get.back(); 
          },
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Store',
          style: TextStyle(color: AppConstants.primaryTextColor),
        ),
        backgroundColor: AppConstants.appBackgroundColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3),
            Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productController.products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productController.products.length,
                itemBuilder: (context, index) {
                  final product = productController.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Get.toNamed('/productDetails/${product.id}');
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
