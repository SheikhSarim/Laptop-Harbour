import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController couponController = TextEditingController();

  CartScreen({super.key});

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
          'Your Cart',
          style: TextStyle(color: AppConstants.primaryTextColor),
        ),
        backgroundColor: AppConstants.appBackgroundColor,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty.'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
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
                                    () => cartController.decreaseQuantity(
                                      item.productId,
                                    ),
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed:
                                    () => cartController.increaseQuantity(
                                      item.productId,
                                    ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: couponController,
                          decoration: const InputDecoration(
                            labelText: 'Coupon Code',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          cartController.applyCoupon(
                            couponController.text.trim(),
                          );
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
                      'Total: '
                      '\$${NumberFormat("#,##0.00", "en_US").format(cartController.totalPrice)}'
                      '${cartController.couponApplied.value ? ' (Discount Applied)' : ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/checkout');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.appButtonColor,
                      foregroundColor: AppConstants.appSecondaryColor,
                      minimumSize: Size(
                        Get.width / 2,
                        Get.height / 18,
                      ), // Set the size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ), // Rounded corners
                      ),
                    ),
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
