import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/models/product_model.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final TextEditingController couponController = TextEditingController();
  final List<ProductModel> products;

  CartScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppConstants.primaryIconColor),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Your Cart',
          style: TextStyle(color: AppConstants.primaryTextColor),
        ),
        backgroundColor: AppConstants.appBackgroundColor,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ready for a new view? Browse our laptops and find your perfect match.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      '/storescreenDrawer',
                    ); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Go to Store',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final product = products.firstWhere(
                    (p) => p.id == item.productId,
                    // Add a fallback
                  );
                  final availableQty = product.quantity;

                  return Card(
                    color: AppConstants.cardColor,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: Image.network(
                        item.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.image),
                      ),
                      title: Text(item.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \$${NumberFormat("#,##0.00", "en_US").format(item.price)}',
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed:
                                    item.quantity > 1
                                        ? () => cartController.decreaseQuantity(
                                          item.productId,
                                        )
                                        : null,
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed:
                                    item.quantity < availableQty
                                        ? () => cartController.increaseQuantity(
                                          item.productId,
                                        )
                                        : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed:
                            () => cartController.removeFromCart(item.productId),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildCartSummary(),
          ],
        );
      }),
    );
  }

  Widget _buildCartSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  decoration: const InputDecoration(labelText: 'Coupon Code'),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  cartController.applyCoupon(couponController.text.trim());
                  if (cartController.couponApplied.value) {
                    Get.snackbar(
                      'Coupon Applied',
                      'Discount applied!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      'Invalid Coupon',
                      'Try again.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: AppConstants.appSecondaryColor,
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              'Total: \$${NumberFormat("#,##0.00", "en_US").format(cartController.totalPrice)}'
              '${cartController.couponApplied.value ? ' (Discount Applied)' : ''}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Get.toNamed('/checkout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.appButtonColor,
              foregroundColor: AppConstants.appSecondaryColor,
              minimumSize: Size(Get.width / 2, Get.height / 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: const Text('Proceed to Checkout'),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
