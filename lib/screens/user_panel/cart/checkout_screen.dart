import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laptops_harbour/controllers/cart_controller.dart';
import 'package:laptops_harbour/controllers/checkout_controller.dart';
import 'package:laptops_harbour/utils/constants/app_constants.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.put(CartController());
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final TextEditingController addressController = TextEditingController();

  String selectedPayment = 'Credit Card';
  final List<String> paymentMethods = [
    'Credit Card',
    'Cash on Delivery',
    'PayPal',
  ];

  static const double shippingFee = 500.0;

  Future<void> _placeOrder() async {
    final orderAmount = cartController.couponApplied.value
        ? cartController.totalPrice / (1 - cartController.couponDiscount)
        : cartController.totalPrice;
    final discountedOrderAmount = cartController.totalPrice;
    final totalAmount = discountedOrderAmount + shippingFee;
    final error = await checkoutController.placeOrder(
      addressController.text,
      orderAmount: orderAmount,
      shippingFee: shippingFee,
      totalAmount: totalAmount,
      paymentMethod: selectedPayment,
    );
    if (error != null) {
      Get.snackbar('Error', error);
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          backgroundColor: AppConstants.surfaceColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(16),
                child: const Icon(Icons.celebration, color: AppConstants.primaryColor, size: 60),
              ),
              const SizedBox(height: 16),
              const Text('Thank You!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppConstants.primaryColor)),
            ],
          ),
          content: const Text(
            'Your order has been placed successfully!\nWe appreciate your purchase.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppConstants.primaryTextColor),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.offAllNamed('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: AppConstants.surfaceColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Continue Shopping', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cartController.cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text('Checkout'),
          backgroundColor: AppConstants.primaryColor,
        ),
        body: const Center(child: Text('Your cart is empty.')),
      );
    }

    final orderAmount = cartController.couponApplied.value
        ? cartController.totalPrice / (1 - cartController.couponDiscount)
        : cartController.totalPrice;
    final discountedOrderAmount = cartController.totalPrice;
    final totalAmount = discountedOrderAmount + shippingFee;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Checkout'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: Obx(() => checkoutController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(hintText: 'Enter your address'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...cartController.cartItems.map((item) => ListTile(
                        title: Text(item.title),
                        subtitle: Text('x${item.quantity}'),
                        trailing: Text(NumberFormat.simpleCurrency().format(item.price * item.quantity)),
                      )),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Order:', style: TextStyle(fontSize: 16)),
                      Text(NumberFormat.simpleCurrency().format(orderAmount)),
                    ],
                  ),
                  if (cartController.couponApplied.value)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount:', style: TextStyle(fontSize: 16, color: Colors.green)),
                        Text('-' + NumberFormat.simpleCurrency().format(orderAmount - discountedOrderAmount), style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Shipping:', style: TextStyle(fontSize: 16)),
                      Text(NumberFormat.simpleCurrency().format(shippingFee)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(NumberFormat.simpleCurrency().format(totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...paymentMethods.map((method) => RadioListTile<String>(
                        title: Text(method),
                        value: method,
                        groupValue: selectedPayment,
                        activeColor: AppConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            selectedPayment = value!;
                          });
                        },
                      )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.appButtonColor,
                        foregroundColor: AppConstants.appSecondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Confirm & Purchase'),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}
